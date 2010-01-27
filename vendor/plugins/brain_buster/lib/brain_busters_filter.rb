# DEPRECATED - please see BrainBusterFilters (note the different pluralization), which should have
# filters to handle everything for you
#
# This will be removed in a future version!
class BrainBustersFilter
  # finds a captcha and assigns it - will either find a random captcha or a previous captcha from params
  def self.filter(controller)
    controller.assigns[:captcha] = BrainBuster.find_random_or_previous(controller.params[:captcha_id])
  end
end
