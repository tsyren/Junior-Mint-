require File.join(File.dirname(__FILE__), 'brain_buster_test_helper')

ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action/:id' }

# Fake controller, with a standard show action that where we initialize the captcha,
# and an update action where the captcha has to be verified.
class StubController < ActionController::Base
  before_filter :create_brain_buster, :only => [:show]
  before_filter :validate_brain_buster, :only => [:update]

  def show() render :text => "Here is a model object.  It is awesome."; end;
  def update() render :text => "Success!"; end;
  def rescue_action(e) raise e end;
  
end

context "Brain Buster with filters" do
  include BrainBusterTestHelper
  
  setup do
    @controller = StubController.new
    @controller.brain_buster_salt = [Array.new(32){rand(256).chr}.join].pack("m").chomp
    @controller.logger = logger
    logger.debug("\n" << "=" * 80 << "\n#{name}\n" << "=" * 80)
    
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.brain_buster_enabled = true
  end
  
  specify "should add brain_buster_salt class instance variable method to ActionController::Base" do
    ActionController::Base.should.respond_to(:brain_buster_salt)
    @controller.should.respond_to(:brain_buster_salt)
  end
  
  specify "should raise an exception if the salt doesnt get set to something" do
    @controller.brain_buster_salt = nil
    lambda { get(:show) }.should.raise(RuntimeError)
  end
  
  specify "should ignore filters if brain buster is not enabled" do
    @controller.brain_buster_enabled = false
    BrainBuster.expects(:find_random_or_previous).never
    post :update
    @response.body.should == "Success!"
  end
  
  specify "should alias captcha_passed? method" do
    BrainBuster.expects(:find_random_or_previous).with(nil).returns(default_stub)
    get :show
    @controller.should.respond_to :captcha_passed?
    @controller.should.respond_to :captcha_previously_passed?    
    @controller.captcha_passed?.should.be @controller.captcha_previously_passed?
  end
    
  specify "should create captcha for first request" do
    BrainBuster.expects(:find_random_or_previous).with(nil).returns(default_stub)
    get :show
    @controller.assigns[:captcha].should == default_stub
  end
  
  specify "should retrieve same captcha for second request" do
    BrainBuster.expects(:find_random_or_previous).with('1').returns(default_stub)
    get :show, :captcha_id => '1'
    @controller.assigns[:captcha].should == default_stub
  end
  
  specify "should fail validation and halt action if captcha is missing" do
    post :update
    flash[:error].should == @controller.brain_buster_error_message
    @response.body.should == ""
  end
  
  specify "should indicate previous captcha attempt failed with a cookie" do 
    BrainBuster.expects(:find_random_or_previous).with('1').returns(default_stub)
    post :update, :captcha_id => '1', :captcha_answer => "5"
    flash[:error].should == @controller.brain_buster_error_message
    cookies['captcha_status'].should == [BrainBusterSystem.encrypt("failed", @controller.brain_buster_salt)]
  end
  
  specify "should fail validation and halt action if captcha answer fails" do 
    BrainBuster.expects(:find_random_or_previous).with('1').returns(default_stub)
    post :update, :captcha_id => '1', :captcha_answer => "5"
    @controller.assigns[:captcha].should == default_stub
    @controller.params[:captcha_id].should == '1'
    @response.body.should == ""
  end
  
  specify "should validate captcha answer and continue action on success" do
    BrainBuster.expects(:find_random_or_previous).with('1').returns(default_stub)
    post :update, :captcha_id => '1', :captcha_answer => "Four"
    @controller.assigns[:captcha].should == default_stub
    @response.body.should == "Success!"
  end
  
  specify "should bypass captcha and never hit the database if it has been previously passed" do
    BrainBuster.expects(:find_random_or_previous).never
    @request.cookies["captcha_status"] = CGI::Cookie.new('captcha_status', BrainBusterSystem.encrypt("passed", @controller.brain_buster_salt))
    
    post :update
    @response.body.should == "Success!"
  end
  
  def default_stub
    stub_brain_buster(:question => "What is 2 + 2 ?", :answer => "4")
  end
  
end