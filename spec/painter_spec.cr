require "./spec_helper"

PAINTER_WIDTH = 10
PAINTER_HEIGHT = 2

describe TUI::Painter do
  painter = TUI::Painter.new(PAINTER_WIDTH, PAINTER_HEIGHT)

  describe "#new" do
    it "can be created" do
      painter.should be_a TUI::Painter
    end
    
    it "has a set width and height" do
      painter.w.should eq PAINTER_WIDTH
      painter.h.should eq PAINTER_HEIGHT
    end

    it "should store a grid of cells" do
      painter[0, 0].should be_a TUI::Cell
    end

    it "sets default values to the surface" do
      painter[0, 0].should eq TUI::Cell.new(' ')
    end
  end

  describe "#[]" do
    it "reads from a valid index" do
      painter[0, 0].should be_truthy
      painter[9, 0].should be_truthy
      painter[0, 1].should be_truthy
    end

    it "reads from a negative index" do
      painter[ -1, -1].should be_truthy
      painter[-10, -2].should be_truthy
    end

    it "raises on invalid index" do
      expect_raises(IndexError) { painter[ 10,   0] }
      expect_raises(IndexError) { painter[  0,   2] }
      expect_raises(IndexError) { painter[ 20,  15] }
      expect_raises(IndexError) { painter[-11,   0] }
      expect_raises(IndexError) { painter[  0,  -3] }
      expect_raises(IndexError) { painter[-50, -30] }
    end
  end

  describe "#[]?" do
    it "reads from a valid index" do
      painter[0, 0]?.should be_truthy
      painter[9, 0]?.should be_truthy
      painter[0, 1]?.should be_truthy
    end

    it "reads from a negative index" do
      painter[ -1, -1]?.should be_truthy
      painter[-10, -2]?.should be_truthy
    end

    it "returns nil on invalid index" do
      painter[ 10,   0]?.should be_nil
      painter[  0,   2]?.should be_nil
      painter[ 20,  15]?.should be_nil
      painter[-11,   0]?.should be_nil
      painter[  0,  -3]?.should be_nil
      painter[-50, -30]?.should be_nil
    end
  end

  describe "#[]=" do
    it "can change a cell" do
      p = TUI::Painter.new(10, 8)
      p[0, 0] = TUI::Cell.new('T')
      p[0, 0].should eq TUI::Cell.new('T')
      p[9, 7] = TUI::Cell.new('S')
      p[9, 7].should eq TUI::Cell.new('S')
    end

    it "can change a cell to a character" do
      p = TUI::Painter.new(10, 8)
      p[0, 0] = 'T'
      p[0, 0].should eq TUI::Cell.new('T')
      p[9, 7] = 'S'
      p[9, 7].should eq TUI::Cell.new('S')
    end

    it "can add a String" do
      p = TUI::Painter.new(10, 8)
      p[0, 0] = "Hi"
      p[0, 0].should eq TUI::Cell.new('H')
      p[1, 0].should eq TUI::Cell.new('i')
    end

    it "can add a wrapping String" do
      p = TUI::Painter.new(10, 8)
      p[0, 0, 4] = "Hello"
      p[0, 0].should eq TUI::Cell.new('H')
      p[0, 1].should eq TUI::Cell.new('o')

      p2 = TUI::Painter.new(4, 4)
      p2[0, 0] = "Hello"
      p2[0, 0].should eq TUI::Cell.new('H')
      p2[0, 1].should eq TUI::Cell.new('o')
    end
  end

  describe "#centre" do
    it "can add centred text" do
      p = TUI::Painter.new(10, 4)
      p.centre(p.w//2, 0, "Test")
      p[3, 0].should eq TUI::Cell.new('T')
      p[6, 0].should eq TUI::Cell.new('t')
    end

    it "drifts left" do
      p = TUI::Painter.new(7, 4)
      p.centre(p.w//2, 0, "Hello")
      p[1, 0].should eq TUI::Cell.new('H')
      p[5, 0].should eq TUI::Cell.new('o')
    end

    it "defaults to the horizontal centre" do
      p = TUI::Painter.new(10, 4)
      p.centre(0, "Test")
      p[3, 0].should eq TUI::Cell.new('T')
      p[6, 0].should eq TUI::Cell.new('t')
    end
  end

  describe "#each" do
    it "yields the correct amount of times" do
      count = 0
      painter.each { count += 1 }
      count.should eq PAINTER_HEIGHT * PAINTER_WIDTH
    end

    it "yields a Cell" do
      painter.each { |v| v.should be_a TUI::Cell }
    end
  end

  describe "#each_with_index" do
    it "yields the correct amount of times" do
      count = 0
      painter.each_with_index { count += 1 }
      count.should eq PAINTER_HEIGHT * PAINTER_WIDTH
    end

    it "yields Cell with x and y coordinates" do
      painter.each_with_index do |cell, x, y|
        cell.should be_a TUI::Cell
        x.should be_a Int32
        y.should be_a Int32
      end
    end
  end

  describe "#each_index" do
    it "yields the correct amount of times" do
      count = 0
      painter.each_index { count += 1 }
      count.should eq PAINTER_HEIGHT * PAINTER_WIDTH
    end

    it "yields x and y coordinates" do
      painter.each_index do |x, y|
        x.should be_a Int32
        y.should be_a Int32
      end
    end
  end

  describe "#clear" do
    it "clears all cells in scope" do
      painter[0, 0].should eq TUI::Cell.new
      painter[0, 0] = TUI::Cell.new('P')
      painter[0, 0].should eq TUI::Cell.new('P')
      painter.clear
      painter[0, 0].should eq TUI::Cell.new
    end

    it "clears all cells in a rect" do
      p = TUI::Painter.new(10, 8)
      p[0, 0] = '1'
      p[4, 3] = '2'
      p.clear(TUI::Rect.new(2, 2, 4, 2))
      p[0, 0].should eq TUI::Cell.new('1')
      p[4, 3].should eq TUI::Cell.new
    end
  end

  describe "#resize" do
    it "can shrink" do
      p = TUI::Painter.new(10, 8)
      p.w.should eq 10
      p.h.should eq 8
      p.resize(8, 6)
      p.w.should eq 8
      p.h.should eq 6
    end

    it "can grow" do
      p = TUI::Painter.new(10, 8)
      p.w.should eq 10
      p.h.should eq 8
      p.resize(12, 10)
      p.w.should eq 12
      p.h.should eq 10
    end

    it "clears the surface" do
      p = TUI::Painter.new(10, 8)
      p[0, 0] = 'T'
      p[0, 0].should eq TUI::Cell.new('T')
      p.resize(12, 8)
      p[0, 0].should eq TUI::Cell.new

      p2 = TUI::Painter.new(10, 8)
      p2[0, 0] = 'T'
      p2[0, 0].should eq TUI::Cell.new('T')
      p2.resize(8, 6)
      p2[0, 0].should eq TUI::Cell.new
    end
  end

  describe "#push & #pop" do
    it "changes size accordingly" do
      painter.w.should eq 10
      painter.h.should eq 2
      painter.push(2, 0)
      painter.w.should eq 8
      painter.h.should eq 2
      painter.push(3, 1)
      painter.w.should eq 5
      painter.h.should eq 1
      painter.push(2, 0, 2)
      painter.w.should eq 2
      painter.h.should eq 1
      painter.push(0, 1, 2, 0)
      painter.w.should eq 2
      painter.h.should eq 0
      painter.push(2, 0)
      painter.w.should eq 0
      painter.h.should eq 0
      painter.pop
      painter.w.should eq 2
      painter.h.should eq 0
      painter.pop
      painter.w.should eq 2
      painter.h.should eq 1
      painter.pop
      painter.w.should eq 5
      painter.h.should eq 1
      painter.pop
      painter.w.should eq 8
      painter.h.should eq 2
      painter.pop
      painter.w.should eq 10
      painter.h.should eq 2
    end

    it "raises on negative push inputs" do
      expect_raises(ArgumentError) { painter.push(-1, 0) }
      expect_raises(ArgumentError) { painter.push(0, -2) }
      expect_raises(ArgumentError) { painter.push(0, 0, -3, Int32::MAX) }
      expect_raises(ArgumentError) { painter.push(0, 0, Int32::MAX, -4) }
      expect_raises(ArgumentError) { painter.push(-5, -6) }
      expect_raises(ArgumentError) { painter.push(0, 0, -7, -8) }
      expect_raises(ArgumentError) { painter.push(-9, -1, -2, Int32::MAX) }
      expect_raises(ArgumentError) { painter.push(-3, -4, Int32::MAX, -5) }
      expect_raises(ArgumentError) { painter.push(-6, 0, -7, -8) }
      expect_raises(ArgumentError) { painter.push(0, -9, -1, -2) }
    end
  end
end
