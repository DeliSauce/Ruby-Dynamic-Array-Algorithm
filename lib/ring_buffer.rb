require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    self.store = Array.new(8, nil)
    @start_idx = 0
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    if index > @length - 1
      raise "index out of bounds"
    else
      self.store[(index + @start_idx) % @capacity]
    end
  end

  # O(1)
  def []=(index, val)
    self.store[(index + @start_idx) % @capacity] = val
  end

  # O(1)
  def pop
    if @length == 0
      raise "index out of bounds"
    end
    el = self.store[(@length - 1 + @start_idx) % @capacity]
    self.store[(@length - 1 + @start_idx) % @capacity] = nil
    @length -= 1
    return el
  end

  # O(1) ammortized
  def push(val)
    if @length == @capacity
      resize!
    end
    self.store[(@length + @start_idx) % @capacity] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length == 0
      raise "index out of bounds"
    end
    shifted = self.store[@start_idx]
    self.store[@start_idx] = nil
    @start_idx += 1
    if (@start_idx == @capacity)
      @start_idx = 0
    end
    @length -= 1
    return shifted
  end

  # O(1) ammortized
  def unshift(val)
    if @length == @capacity
      resize!
    end
    @start_idx = (@start_idx == 0 ? @capacity - 1 : @start_idx - 1)
    self.store[@start_idx] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    @capacity = @capacity * 2
    new_store = Array.new(@capacity)

    @length.times do |i|
      new_store[i] = self.store[(i + @start_idx) % @length]
    end
    @start_idx = 0
    self.store = new_store
  end
end
