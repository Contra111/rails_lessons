class PassengerTrain < Train
  def initialize(number)
    super
    @type = 'Passenger'
  end
end