class Admin::DashboardsController < Admin::BaseController

  def index
    @page_title = 'Dashboard'
    @registrations = Registration.active
  end

  def results
    @data = []
    ['NIR', 'NCR', 'REGION_I', 'REGION_II', 'REGION_III', 'CAR', 'REGION_IV-A', 'REGION_IV-B', 'REGION_V', 'REGION_VI', 'REGION_VII', 'REGION_VIII', 'REGION_IX', 'REGION_X', 'REGION_XI', 'REGION_XII', 'REGION_XIII', 'ARMM', 'OAV'].each do |region|
      response = HTTParty.get("http://eleksyondata.gmanews.tv/all_lvgs_results/#{region}.json.gz")
      response= JSON.parse(response.body)
      vp_data = response['result'][1]
      @data << response
    end


    #render json: @data.collect {|x| x['result'][1]['candidates'][0]['vote_count'].to_i }.sum
    #render json: @data.collect {|x| x['result'][1]['candidates'] }
  end
end
