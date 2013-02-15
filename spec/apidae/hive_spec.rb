# encoding: utf-8

require 'spec_helper'

shared_examples_for "apidae" do

  let(:browser) { Rack::Test::Session.new(Rack::MockSession.new(described_class)) }

  describe "routes" do
    it "should not respond to /" do
      browser.get '/'
      browser.last_response.status.should == 404
    end

    it "should not respond to /plop" do
      browser.get '/plop'
      browser.last_response.status.should == 404
    end

    it "should respond to /browse" do
      browser.get '/browse'
      browser.last_response.status.should == 200
    end

    it "should respond to /browse/" do
      browser.get '/browse/'
      browser.last_response.status.should == 200
    end

    it "should respond to /browse/lib" do
      browser.get '/browse/lib'
      browser.last_response.status.should == 200
    end

    it "should respond to /show/lib/apidae.rb" do
      browser.get '/show/lib/apidae.rb'
      browser.last_response.status.should == 200
    end

    it "should respond to /read/lib/apidae.rb" do
      browser.get '/read/lib/apidae.rb'
      browser.last_response.status.should == 200
    end

  end

  describe '/browse/' do
    it "should display all the designated root directory contents" do
      browser.get '/browse/'

      Dir['*'].all? { |content| browser.last_response.body.include? content }.should be_true
      browser.last_response.body.should_not include('Parent directory')
      browser.last_response.body.should include('Contents of "/"')
      browser.last_response.body.should include('/</title>')
      browser.last_response.body.should include('</style>')
      browser.last_response.status.should eq 200
    end
  end

  describe '/browse/lib' do
    it "should display all the contents of url specified directory" do
      browser.get '/browse/lib'

      Dir['lib/*'].all? { |content| browser.last_response.body.include? File.basename(content) }.should be_true
      browser.last_response.body.should include('Parent directory')
      browser.last_response.body.should include('Contents of "lib/"')
      browser.last_response.body.should include('lib/</title>')
      browser.last_response.body.should include('</style>')
      browser.last_response.status.should eq 200
    end
  end

  describe '/show/lib/apidae.rb' do
    it "should show the content of the url specified text file" do
      browser.get '/show/lib/apidae.rb'

      browser.last_response.body.should include('lib/apidae.rb</title>')
      browser.last_response.body.should include('</style>')
      browser.last_response.body.should include('Parent directory')
      browser.last_response.body.should include('<p>apidae.rb</p>')
      browser.last_response.body.should include(File.read('lib/apidae.rb'))
      browser.last_response.status.should eq 200
    end
  end

  describe '/read/lib/apidae.rb' do
    it "should serve the url specified file contents" do
      browser.get '/read/lib/apidae.rb'

      browser.last_response.body.should == File.read('lib/apidae.rb')
      browser.last_response.status.should eq 200
    end
  end

end

module Wasp
  class Clay < Apidae::Cell; end
  class Nest < Apidae::Hive; end
end

describe Apidae::Hive do
  it_should_behave_like "apidae"

  describe 'run' do
    let(:out) { '' }

    before {
      $stdout = StringIO.new(out, 'w')
      described_class.implant! 'help' => true
    }

    it 'should start normally and exit with the help output' do
     out.should include('Usage : ')
    end

    after {
      $stdout = STDOUT
    }
  end

end

describe Wasp::Nest do
  it_should_behave_like "apidae"
end
