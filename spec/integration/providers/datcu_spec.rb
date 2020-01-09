require 'spec_helper'

# I wrote this so that it only gets auto loans. If we support more types
# of loans in the future, we are going to want to re-organize our providers
# to support that and have libraries for common routines like logging in and
# moving around.
describe "Given a DATCU online account" do
  context "When I log in" do
      example "Then I get a balance", :integration do
        params = { provider: 'datcu' }
        Service.get('/balance',
                    params: params,
                    authenticated: true) do |response|
          status = JSON.parse(response.body)[:status]
          balance = JSON.parse(response.body)[:message]
          expect(response.code).to eq 200
          expect(status).to eq 'ok'
          expect(balance).to match(/^\$[0-9,]{1}/)
        end
      end
  end
end
