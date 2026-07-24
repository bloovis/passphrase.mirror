#!/usr/bin/env ruby

# Generates a passphrase using the Diceware algorithm.
# Five wordlists are available:
# - EFF long word list (default)
# - EFF short list #1
# - EFF short list #2
# - Original Diceware word list
# - Beale word list
#
# Copy the program:
#   sudo cp src/passphrase.rb /usr/local/bin/passphrase
# Copy the word lists:
#   sudo mkdir -p /usr/local/share/passphrase
#   sudo cp wordlists/*.wordlist /usr/local/share/passphrase

require "optparse"
require "securerandom"

class PassPhraseGenerator
  @wordlist = []
  @list_size = 0
  attr_accessor :entropy

  def initialize(filename)
    @wordlist = []
    fullpath = File.join("/usr/local/share/passphrase", filename)
    #puts "Reading #{fullpath}"
    IO.foreach(fullpath) do |line|
      #puts "Word #{line}"
      @wordlist << line.split[1]
    end
    @list_size = @wordlist.size
    @entropy = Math.log2(@list_size.to_f)
    #puts "wordlist size #{@list_size}, entropy = #{@entropy}"
  end

  def random_word
    return @wordlist[SecureRandom.random_number(@list_size)]
  end

  def random_phrase(len, caps, separator)
    words = []
    len.times { words << random_word }
    return words.map { |w| caps ? w.capitalize : w } .join(separator)
  end
end
    
nwords = 6
capitalize = true
nphrases = 1
wordlist = "eff.wordlist"
separator = ""
verbose = false

OptionParser.new do |parser|
  parser.banner = "Usage: passphrase [args]\nGenerates a passphrase using diceware"
  parser.on("-w SIZE", "--words=SIZE",
	    "Specifies the number of words for the passphrase") { |size| nwords = size.to_i }
  parser.on("-n NUMBER", "--phrases=NUMBER",
	    "Specifies the number of passphrases to generate") { |number| nphrases = number.to_i }
  parser.on("-l", "--lowercase", "Don't capitalize words") { capitalize = false }
  parser.on("-b", "--beale", "Use the Beale word list") { wordlist = "beale.wordlist" }
  parser.on("-d", "--diceware", "Use the Diceware word list") { wordlist = "diceware.wordlist" }
  parser.on("-s", "--short", "Use the EFF short word list") { wordlist = "eff_short.wordlist" }
  parser.on("-a", "--alternate", "Use the alternate EFF short word list") { wordlist = "eff_short2.wordlist" }
  parser.on("-x STRING", "--separator=STRING", "Specifies the word separator") { |str| separator = str }
  parser.on("-v", "--verbose", "Print extra information") { verbose = true }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
end.parse!

if ARGV.size > 0
  puts "Ignoring superfluous args #{ARGV.join(' ')}"
end

g = PassPhraseGenerator.new(wordlist)

if verbose
  total_entropy = g.entropy * nwords.to_f
  printf "Generating %d-word passphrase%s with %.1f bits of entropy using %s:\n",
	 nwords, nphrases == 1 ? "" : "s", total_entropy, wordlist
end

nphrases.times do
  puts g.random_phrase(nwords, capitalize, separator)
end
