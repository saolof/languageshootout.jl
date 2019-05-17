# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# Implementation by Olof Salberger.
#
# Optimized mainly to show off low memory usage while being 
# a reasonable speed improvement over the 
# fastest current implementation.
# May contribute another version with space-time tradeoffs in favor of speed.

using MacroTools: postwalk  # For convenience macro.

macro turnintobytes(expression)  # Replaces all Char literals in an expression with byte literals.
   postwalk(x -> x isa Char ? UInt8(x) : x, expression)
end

const leader =  UInt8('>')
const newline = UInt8('\n')
const revcompdata = @turnintobytes Dict(
   'A'=> 'T', 'a'=> 'T',
   'C'=> 'G', 'c'=> 'G',
   'G'=> 'C', 'g'=> 'C',
   'T'=> 'A', 't'=> 'A',
   'U'=> 'A', 'u'=> 'A',
   'M'=> 'K', 'm'=> 'K',
   'R'=> 'Y', 'r'=> 'Y',
   'W'=> 'W', 'w'=> 'W',
   'S'=> 'S', 's'=> 'S',
   'Y'=> 'R', 'y'=> 'R',
   'K'=> 'M', 'k'=> 'M',
   'V'=> 'B', 'v'=> 'B',
   'H'=> 'D', 'h'=> 'D',
   'D'=> 'H', 'd'=> 'H',
   'B'=> 'V', 'b'=> 'V',
   'N'=> 'N', 'n'=> 'N')

function reversemap!(f,v::AbstractVector{UInt8}, s=first(LinearIndices(v)), n=last(LinearIndices(v)))
    r = n
    i = s
    if v[r] == leader       #
      r-=1                  #
    end                     #
    @inbounds while true
        if v[i] == newline  # If-cases break usefulness of this as a generic function,
           i+=1             # but handle all the newlines and > characters without 
        end                 # any unnecessary array copies or hardcoded line widths.
        if v[r] == newline  #
           r-=1             #
        end                 #
        if i >= r
           break
        end
        v[i], v[r] = f(v[r]), f(v[i])
        i += 1
        r -= 1
    end
    if i==r
      v[r] = f(v[r])
    end
    return v
end

reversecomplement!(block) = reversemap!(x->revcompdata[x],block)

function main(;instream = stdin, outstream = stdout)
   while !eof(instream)
      header = readuntil(instream,newline)
      body = readuntil(instream,UInt8('>'))
      write(outstream, header)
      write(outstream,reversecomplement!(body))
   end
end

main()
