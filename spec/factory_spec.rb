require 'factory'

RSpec.describe Factory do
  before :all do
    @name = 'NAME'
    @surname = 'SURNAME'
    @structure_classes = Array.new

    block = Proc.new do
      def greeting
        "Hello, #{name}"
      end
    end

    Factory.new 'Customer', :name, :surname, &block
    @structure_classes << Factory::Customer

    structure = Factory.new :name, :surname, &block
    @structure_classes << structure
  end

  before :each do
    @structure_objects = @structure_classes.map { |element| element.new @name, @surname }
  end

  let(:structure_different_objects) do
    [
        @structure_classes[0].new(@name, @name),
        @structure_classes[1].new(@surname, @surname)
    ]
  end

  it 'should not be null after creation' do
    @structure_objects.each { |structure| expect(structure).not_to be_nil }
  end

  it 'should has the same length' do
    @structure_objects.each { |structure| expect(structure.length).to eq 2 }
  end

  it 'should has getters' do
    @structure_objects.each do |structure|
      expect(structure.name).to eq @name
      expect(structure.surname).to eq @surname
    end
  end

  it 'should has setters' do
    @name + 'NEW_NAME'
    @surname + 'NEW_SURNAME'

    @structure_objects.each do |structure|
      structure.name = @name
      structure.surname = @surname

      expect(structure.name).to eq @name
      expect(structure.surname).to eq @surname
    end
  end

  it 'should has method from block' do
    @structure_objects.each do |structure|
      expect(structure.greeting.class).to eq String
    end
  end

  it 'should be equal' do
    expect(@structure_objects.reduce :==).to be_truthy
  end

  it 'should not be equal' do
    expect(structure_different_objects.reduce :==).to be false
  end

  it 'should getters work with [] brackets' do
    @structure_objects.each do |structure|
      expect(structure[0]).to eq @name
      expect(structure['name']).to eq @name
      expect(structure[:surname]).to eq @surname
    end
  end

  it 'should setters work with [] brackets' do
    @name = 'NEW_NAME'
    @surname = 'NEW_SURNAME'

    @structure_objects.each do |structure|
      structure[0] = @name
      expect(structure[0]).to eq @name

      structure['name'] = @name
      expect(structure['name']).to eq @name

      structure[:surname] = @surname
      expect(structure[:surname]).to eq @surname
    end
  end

  it 'should print twice values of all properties in the struct', skip: true do
    @structure_objects.each do |structure|
      structure.each { |value| puts value }
    end
  end

  it 'should print twice names and values of all properties in the struct', skip: true do
    @structure_objects.each do |structure|
      structure.each_pair { |property, value| puts "#{property} => #{value}" }
    end
  end
end