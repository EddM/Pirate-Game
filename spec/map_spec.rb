require 'rubygems'
require 'gosu'

require './game'
require './player'
require './map'
require './rect'

describe Map do
  
  it "generates from a file" do
    @map = Map.new("spec/etc/good_map.txt")
  end
  
  it "should calculate width and height" do
    @map = Map.new("spec/etc/good_map.txt")
    @map.height.should == 11
    @map.width.should == 60
    
    @map.height_in_pixels.should == 11
    @map.width_in_pixels.should == 60
  end
  
  it "handles unknown characters as empty" do
    
  end
  
end