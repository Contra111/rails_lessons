class CargoTrain < Train
  def initialize(number)
    super
    @type = 'Cargo'
  end
end