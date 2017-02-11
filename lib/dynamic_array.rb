require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.store = Array.new(8, nil)
    @length = 0
    @capacity = 8
  end

  # O(1)
  def [](index)
    if index > @length - 1
      raise "index out of bounds"
    else
      self.store[index]
    end
  end

  # O(1)
  def []=(index, value)
    self.store[index] = value
  end

  # O(1)
  def pop
    if self.length == 0
      raise "index out of bounds"
    end
    el = self.store[@length - 1]
    self.store[@length - 1] = nil
    @length -= 1
    return el
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length == @capacity
      resize!
    end
    self.store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length == 0
      raise "index out of bounds"
    end
    shifted = self.store[0]
    (@length - 1).times do |i|
      self.store[i] = self.store[i + 1]
    end
    @length -= 1
    return shifted
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if @length == @capacity
      resize!
    end
    (@length - 1).downto(0) do |i|
      self.store[i + 1] = self.store[i]
    end
    @length += 1
    self.store[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity = @capacity * 2
    new_store = Array.new(@capacity)

    @length.times do |i|
      new_store[i] = self.store[i]
    end
    self.store = new_store
  end
end
