class Array
  def to_proc
    proc { |receiver| receiver.send *self }
  end
end
