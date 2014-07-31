# /r/dailyprogrammer Challenge #162 - Intermediate
# http://www.reddit.com/r/dailyprogrammer/comments/25hlo9/5142014_challenge_162_intermediate_novel/

    class String
      def compress
        dictionary = scan(/\w+/).map {|w| w.downcase}.uniq
        output = ([dictionary.length.to_s] + dictionary).join("\n") + "\n"
        scan(/\.|,|\?|!|;|:|\n|\w+|./).each do |piece|
          case piece
          when *[".", ",", "?", "!", ";", ":"]  then output += "#{piece} "
          when "\n" then output += "R "
          when /\w+/
            case piece
            when piece.downcase then output += dictionary.index(piece).to_s + " "
            when piece.capitalize then output += dictionary.index(piece.downcase).to_s + "^ "
            when piece.upcase then output += dictionary.index(piece.downcase).to_s + "! "
            else raise "Improper capitalization in \"#{piece}\""
            end
          when " "
          else raise "Illegal character: \"#{piece}\""
          end
        end
        output + "E"
      end
    end

    input = gets nil

    puts input.compress