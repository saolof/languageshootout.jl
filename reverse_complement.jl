# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# Implementation by Olof Salberger.
#
# Optimized mainly to show off low memory usage while being 
# a reasonable speed improvement over the 
# fastest current implementation.
# May contribute another version with space-time tradeoffs in favor of speed.

const leader =  UInt8('>')
const newline = UInt8('\n')             #  ABCDEFGHIJKLMNOPQRSTUVWXYZ      abcdefghijklmnopqrstuvwxyz
const complement_hasharr = Vector{UInt8}(" TVGH  CD  M KN   YSAABW R       TVGH  CD  M KN   YSAABW R")

complement(charbyte::UInt8)  = complement_hasharr[charbyte - 0x3f]

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

reversecomplement!(block) = reversemap!(complement, block)

function main(;instream = stdin, outstream = stdout)
   while !eof(instream)
      header = readuntil(instream,newline)
      body = readuntil(instream,UInt8('>'))
      write(outstream, header)
      write(outstream,reversecomplement!(body))
   end
end

main()
