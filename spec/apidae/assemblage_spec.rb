# encoding: utf-8

require 'spec_helper'

describe Apidae::Wax::Assemblage do

   its(:title) { should include('Apidae Hive -') }
   its(:title_stub) { should include('Apidae Hive -') }
   its(:body) { should == "\n" }

   describe '<<' do
     it 'should push content to the body' do
       (subject << 'plop').should == subject
       subject.body.should include('plop')
     end
   end

end
