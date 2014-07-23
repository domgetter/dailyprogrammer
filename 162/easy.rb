# /r/dailyprogrammer Challenge #162 - Easy
# http://www.reddit.com/r/dailyprogrammer/comments/25clki/5122014_challenge_162_easy_novel_compression_pt_1/

class String
  def decompress
    input = self.split("\n")
    output = ""
    dictionary_length = input[0].to_i
    dictionary = input[1..(dictionary_length+1)]
    lines = input[(dictionary_length+1)..(-1)]
    lines.each do |line|
      line.split(" ").each do |word|
        match = word.match(/(?:(?<word_index>[0-9]+)(?<format>\^|!)?)|(?<punctuation>R|E|-|\.|,|\?|!|;|:)/)
        if match[:word_index]
          case match[:format]
          when "!" then output += dictionary[match[:word_index].to_i].upcase
          when "^" then output += dictionary[match[:word_index].to_i].capitalize
          else output += dictionary[match[:word_index].to_i]
          end
          output += " "
        else
          case match[:punctuation]
          when "!" then output[-1] = "! "
          when "R" then output[-1] = "\n"
          end
        end
      end
    end
    output
  end
end

challenge_input = "20
i
do
house
with
mouse
in
not
like
them
ham
a
anywhere
green
eggs
and
here
or
there
sam
am
0^ 1 6 7 8 5 10 2 . R
0^ 1 6 7 8 3 10 4 . R
0^ 1 6 7 8 15 16 17 . R
0^ 1 6 7 8 11 . R
0^ 1 6 7 12 13 14 9 . R
0^ 1 6 7 8 , 18^ - 0^ - 19 . R E"

puts challenge_input.decompress