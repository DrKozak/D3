require 'sinatra'
require 'sinatra/reloader'


# If a get request comes in at /, do this

get '/' do
  # Get the parameter and store it in variables
  tru_symbol = params['true']
  fal_symbol = params['false']
	table = params['truth_table']
	x_size = params['x_size']
	
	#instance variables (outside of local scope)
	#set to invalid value to start
	@invalid_param = false
	
	@generate_Table = nil
	
	if table.nil?
			@generate_Table = nil
	else
			@generate_Table = 1
	end
#default settings for the table generation here
  if tru_symbol.nil?
		@truth = 'T'
	elsif tru_symbol == ''
		@truth = 'T'
	elsif tru_symbol.length > 1
		@invalid_param = true
		not_found
	else
		@truth = tru_symbol
	end
	
	if fal_symbol.nil?
		@falseth = 'F'
	elsif fal_symbol == ''
		@falseth = 'F'
	elsif fal_symbol.length > 1
		@invalid_param = true
		not_found
	else
		@falseth = fal_symbol
	end
	
	if x_size.nil?
		@size_table = 3
	elsif x_size == ''
		@size_table = 3
	else
		unless x_size.is_i?
			@invalid_param = true
			not_found
		end
		@size_table = x_size.to_i
		if @size_table < 2
			@invalid_param = true
			not_found
		end
			
  end
	
	if @truth == @falseth
		@invalid_param = true
		not_found
	end
	
	create_Table
  erb :index
end

#tokenizer to reject anything but valid characters for input into table
class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

not_found do
  status 404
  erb :error
end




#generate table if it is not the default settings
def create_Table	
#instance variables
@operators = []
@and_or_xor

	#start at 0, for ex 2^4(size table) default would be 16 indexes 0-15 on table
	for n in (0..((2**@size_table)-1))
		v = (("%0" + @size_table.to_s + "b") % n)
		op = v.split('')
		#op splits the and, or, xor results where v has the concatanated form
		for i in (0..(@size_table-1))
			@operators << op[i]
		end

		@and_or_xor = 0
		
		for i in (0..(op.size-1))
			if op[i] == 1.to_s
				@and_or_xor += 1
			end
		end
		#<< append and or xor and show the results of each row
		if @and_or_xor == op.size
			@operators << 1
		else
			@operators << 0
		end
		
		if @and_or_xor > 0
			@operators << 1
		else
			@operators << 0
		end
		
		if @and_or_xor % 2 == 1
			@operators << 1
		else
			@operators << 0
		end
		
	end
	
end

