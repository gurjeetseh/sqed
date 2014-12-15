require 'spec_helper'

describe Sqed do

  let(:s) {Sqed.new}

  context 'attributes' do
    specify '#image' do
      expect(s).to respond_to(:image)
    end

    specify '#pattern' do
      expect(s).to respond_to(:pattern)
    end

    specify '#stage_image' do
      expect(s).to respond_to(:image)
    end
  end

  context 'initialization' do 
    specify 'without providing a pattern assigns :standard_cross' do
      expect(s.pattern).to eq(:standard_cross)
    end
  end

  context 'asking for a result' do
    specify 'without providing an image returns false' do
      expect(s.result).to eq(false)
    end
  end

  context 'with a test image' do
    let(:a) { ImageHelpers.test0_image }
    before {
      s.image = a
    }

    specify '#crop_image' do        #should expand to multiple cases of image border types
      expect(s.crop_image).to be_truthy
      expect(s.stage_image.columns < a.columns).to be(true)
      expect(s.stage_image.rows < a.rows).to be(true)
    end

    specify '#boundaries returns a Sqed::Boundaries instance' do
      s.pattern = :standard_cross
      expect(s.boundaries.class).to eq(Sqed::Boundaries)
    end
  end

  context 'stage image with a border' do
    let(:a) { ImageHelpers.standard_cross_green }
    before {
      s.image = a
      s.crop_image
    }
    specify 'stage boundary is created for standard_ cross_green ~ (100,94, 800, 600)' do
      expect(s.stage_boundary.x_for(0)).to be_within(2).of 100
      expect(s.stage_boundary.y_for(0)).to be_within(2).of 94
      expect(s.stage_boundary.width_for(0)).to be_within(2).of 800
      expect(s.stage_boundary.height_for(0)).to be_within(2).of 600
    end
  end

  context 'offset boundaries from original crossy_green_line_specimen image ' do
    before(:all) {
      @s = Sqed.new(image: ImageHelpers.crossy_green_line_specimen, pattern: :offset_cross)
      @s.crop_image
      @offset_boundaries = @s.boundaries.offset(@s.stage_boundary)
      wtf = 0
    }

    specify "offset and size should match internal found areas " do
      sbx = @s.stage_boundary.x_for(0)
      sby = @s.stage_boundary.y_for(0)

      sl =  @s.boundaries.coordinates.length  # may be convenient to clone this model for other than 4 boundaries found
      expect(sl).to eq(4)    #for offset cross pattern and valid image
      expect(@s.boundaries.complete).to be(true)
      expect(@offset_boundaries.complete).to be(true)
      (0..sl - 1).each do |i|
        # check all the x/y      
        expect(@offset_boundaries.x_for(i)).to eq(@s.boundaries.x_for(i) + sbx)
        expect(@offset_boundaries.y_for(i)).to eq(@s.boundaries.y_for(i) + sby)

        # check all width/heights
        expect(@offset_boundaries.width_for(i)).to eq(@s.boundaries.width_for(i))
        expect(@offset_boundaries.height_for(i)).to eq(@s.boundaries.height_for(i))
      end
    end

    specify "find image, barcode, and text content" do
      bc = Sqed::Extractor.new(boundaries: [0, 0, @s.image.columns, @s.image.rows], image: @s.image, layout: :offset_cross)
      poc = Sqed::Parser::OcrParser.new(bc.extract_image(@offset_boundaries.coordinates[1]))
      expect(poc.text).to eq('000085067')
    end

  end

  context 'offset boundaries from crossy_black_line_specimen image ' do
    before(:all) {
      @s = Sqed.new(image: ImageHelpers.crossy_black_line_specimen, pattern: :offset_cross, boundary_color: :black)
      @s.crop_image
      @offset_boundaries = @s.boundaries.offset(@s.stage_boundary)
      wtf = 0
    }

    specify "offset and size should match internal found areas " do        ##**** actually fails

      sbx = @s.stage_boundary.x_for(0)
      sby = @s.stage_boundary.y_for(0)

      sl =  @s.boundaries.coordinates.length  # may be convenient to clone this model for other than 4 boundaries found
      expect(sl).to eq(4)    #for offset cross pattern and valid image
      expect(@s.boundaries.complete).to be(true)
      expect(@offset_boundaries.complete).to be(true)
      (0..sl - 1).each do |i|
        # check all the x/y
        expect(@offset_boundaries.x_for(i)).to eq(@s.boundaries.x_for(i) + sbx)
        expect(@offset_boundaries.y_for(i)).to eq(@s.boundaries.y_for(i) + sby)

        # check all width/heights
        expect(@offset_boundaries.width_for(i)).to eq(@s.boundaries.width_for(i))
        expect(@offset_boundaries.height_for(i)).to eq(@s.boundaries.height_for(i))
      end
    end
  end
  context 'offset boundaries from original red_line image ' do
    before(:all) {
      @s = Sqed.new(image: ImageHelpers.offset_cross_red, pattern: :right_t, boundary_color: :red)
      @s.crop_image
      @offset_boundaries = @s.boundaries.offset(@s.stage_boundary)
      wtf = 0
    }

    specify "offset and size should match internal found areas " do
      sbx = @s.stage_boundary.x_for(0)  # only a single boundary
      sby = @s.stage_boundary.y_for(0)
      pct = 0.02

      sl =  @s.boundaries.coordinates.length  # may be convenient to clone this model for other than 4 boundaries found
      expect(sl).to eq(3)    #for offset cross pattern and valid image
      expect(@s.boundaries.complete).to be(true)
      expect(@offset_boundaries.complete).to be(true)
      expect(@s.stage_boundary.width_for(0)).to be_within(pct*800).of(800)
      expect(@s.stage_boundary.height_for(0)).to be_within(pct*600).of(600)
      (0..sl - 1).each do |i|
        # check all the x/y
        expect(@offset_boundaries.x_for(i)).to eq(@s.boundaries.x_for(i) + sbx)
        expect(@offset_boundaries.y_for(i)).to eq(@s.boundaries.y_for(i) + sby)

        # check all width/heights
        expect(@offset_boundaries.width_for(i)).to eq(@s.boundaries.width_for(i))
        expect(@offset_boundaries.height_for(i)).to eq(@s.boundaries.height_for(i))
      end
    end
  end
end
