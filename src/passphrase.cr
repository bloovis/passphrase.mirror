# Generates a passphrase using the Diceware algorithm.
# Three wordlists are available:
# - EFF long word list (default)
# - Original Diceware word list
# - Beale word list
#
# Build the program using:
#   crystal build passphrase.cr
# Copy the word lists:
#   sudo mkdir -p /usr/local/share/passphrase
#   sudo cp wordlists/*.wordlist /usr/local/share/passphrase

require "option_parser"

class PassPhraseGenerator
  @wordlist : Array(String)

  def initialize(filename)
    @wordlist = [] of String
    fullpath = Path.new("/usr/local/share/passphrase", filename)
    #puts "Reading #{fullpath}"
    File.each_line(fullpath) do |line|
      #puts "Word #{line}"
      @wordlist << line.split[1]
    end
    #puts "wordlist size #{@wordlist.size}"
  end

  def roll : Int32
    n = 0
    5.times do
      n = (n * 6) + Random.rand(6)
    end
    return n
  end

  def new_phrase(len : Int32, capitalize : Bool) : String
    phrase = ""
    len.times do
      i = roll
      #puts "rolled #{i}"
      word = @wordlist[i]
      if capitalize
	phrase = phrase + @wordlist[i].capitalize
      else
	phrase = phrase + @wordlist[i]
      end
    end
    return phrase
  end
end
    
nwords = 5
beale = false
capitalize = true
nphrases = 1
wordlist = "eff.wordlist"

OptionParser.parse do |parser|
  parser.banner = "Usage: passphrase [args]\nGenerates a passphrase using the EFF wordlist"
  parser.on("-s SIZE", "--size=SIZE",
	    "Specifies the number of words for the passphrase") { |size| nwords = size.to_i }
  parser.on("-n NUMBER", "--phrases=NUMBER",
	    "Specifies the number of passphrases to generate") { |number| nphrases = number.to_i }
  parser.on("-c", "--nocaps", "Don't capitalize words") { capitalize = false }
  parser.on("-b", "--beale", "Use the Beale word list") { wordlist = "beale.wordlist" }
  parser.on("-d", "--diceware", "Use the Diceware word list") { wordlist = "diceware.wordlist" }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.missing_option do |flag|
    STDERR.puts "ERROR: #{flag} is missing an argument."
    STDERR.puts parser
    exit(1)
  end
end

g = PassPhraseGenerator.new(wordlist)
nphrases.times do
  puts g.new_phrase(nwords, capitalize)
end
