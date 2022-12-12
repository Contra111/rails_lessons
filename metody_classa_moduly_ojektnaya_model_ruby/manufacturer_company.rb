module ManufacturerCompany
  def set_manufacturer_company
    puts 'Введите компанию производителя : '
    @manufacturer_company = gets.chomp
  end
  def get_manufacturer_company
    @manufacturer_company
  end
end