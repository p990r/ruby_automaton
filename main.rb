require 'open3'
require 'graphviz'
require 'rspec/autorun'

# Get number of state from string
# s is start index
def fromStateString(line, s)
	i = s
	until line[i] == '	' || i == line.length
		i = i+1
		if i>7
			puts 'ERROR: cannot read line in fromStateString'
			return -1
		end
	end
	return line[s..i-1]
end

# Find next states
def getState(stdin, stdout, wait_thr, command)
	next_states = Array.new

	stdin.puts(command)
	next_line = stdout.gets.strip
	#puts next_line

	##
	# Continue processing the output of the expand command
	# until we encounter 'EE'
	until next_line == 'EE'

		# If it's not a description of an event to a next state
		# we continue to the next available line on stdout
		if next_line[0..1] != 'Ee'
			next_line = stdout.gets.strip
			#puts next_line
			next
		end

		# Get next state(s) from event
		next_states << fromStateString(next_line, 3)
		#puts next_states
		
		# Read next since this was not an 'EE' yet
		next_line = stdout.gets.strip
		#puts next_line
	end
	#puts next_states
	return next_states
end

# Get number and return a string with the number
def getCommand(state)
	return 'e ' << state.to_s
end

# There should be a more efficient way to iterate an array but I'm new to this language
def checkExist(state)
	i=0
	until i==$transition_array.length
		if $transition_array[i][0] == state
			return true
		end
		i = i+1
	end
	return false
end

def rec(stdin, stdout, wait_thr, state)
	state = state.to_i
	
	# End condition: state is already in array
	if(checkExist(state))
		return -1
	end
	
	command = getCommand(state)
	next_states = getState(stdin, stdout, wait_thr, command)
	$transition_array << [state, next_states]
	next_states.each { |state| rec(stdin, stdout, wait_thr, state) }
end

stdin, stdout, wait_thr = Open3.popen2e "./pos.tx"
$transition_array = Array.new
rec(stdin, stdout, wait_thr, 0)

$transition_array.each { |val| 
	puts val
	puts '' }

# Draw automaton
def draw()
	g = nil
	if ARGV[0]
	  g = GraphViz::new( "G", :path => ARGV[0] )
	else
	  g = GraphViz::new( "G" )
	end
	
	i=0
	until i==$transition_array.length
		$transition_array[i][0] = g.add_nodes ($transition_array[i][0].to_s)
		i = i+1
	end
	
	i=0
	until i==$transition_array.length
		j=1
		until j==$transition_array[i].length
			g.add_edges( $transition_array[i][0], $transition_array[i][j] )
			j = j+1
		end
		i = i+1
	end

	g.output( :png => "output.png" )
end

draw()

describe '#fromStateString' do
	it 'should take a the number from the end of a string' do
		expect(fromStateString('a 123', 2)).to eq 123.to_s
	end
	it 'should take a the number from the end of a string' do
		expect(fromStateString('Ee	321', 3)).to eq 321.to_s
	end
end

describe '#getCommand' do
	it 'should convert a number to the command it will send the executable' do
		expect(getCommand(555)).to eq 'e 555'
	end
end

describe '#checkExist' do
	it 'check if state is in array of states' do
		expect(checkExist(5)).to eq true
	end
	it 'check if state is in array of states' do
		expect(checkExist(5295478)).to eq false
	end
end

