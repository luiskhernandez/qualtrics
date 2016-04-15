require 'httparty'

module Qualtrics
end

module Qualtrics
  BASE_URL = 'https://welltok.co1.qualtrics.com/API/v3/'
  TOKEN = ''

  class Survey
    include HTTParty
    attr_accessor :id, :headers

    def initialize(opts = {})
      @id = opts[:survey_id]
      @results = nil
      @info = nil
      @headers = {'X-API-TOKEN' => Qualtrics::TOKEN }
      fetch
    end

    def info
      @info.parsed_response
    end

    def responses
      resp = get_response_file export_response_as_json
      file = resp.parsed_response["result"]["file"]
      self.class.get(file, verify: false, headers: headers)
    end

    private
    def fetch
      @info =  self.class.get("#{Qualtrics::BASE_URL}surveys/#{id}", headers: headers, verify: false)
    end

    def export_response_as_json
      body = {surveyId: id, format: 'json'}.to_json
      resp =self.class.post("#{Qualtrics::BASE_URL}responseexports", headers: headers.merge({'Content-Type' => 'application/json'}), body: body,  verify: false)
      resp.parsed_response["result"]["id"]
    end

    def get_response_file(result_id)
      self.class.get("#{Qualtrics::BASE_URL}responseexports/#{result_id}", headers: headers, verify: false)
    end
  end
end

#sso_generator_test
survey_id = 'SV_08sAouyzOHaKSjP'
survey = Qualtrics::Survey.new(survey_id: survey_id)

