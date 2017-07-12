# Realms

Star Realms is a spaceship combat deckbuilding game created by [White Wizard Games](http://www.whitewizardgames.com/). Very little of this will make sense if you've never played the game. So I'd suggest you head over to the [official rules]((http://www.starrealms.com/learn-to-play/) to get an idea of how the game is played.

This gem is a generic implementation of the StarRealms game system. It can be used to simulate and script the playing of games.

I've created this to learn about and practice implementing strategic digital card games. If you're reading this and are also interested, shoot me an email.

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)
* [Copyright](#copyright)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'realms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install realms

## Usage

I present to you, kind reader, the world's most uninteresting StarRealms game -- death by Viper.

```ruby
game = Realms::Game.new
game.start

until game.over?
  hand = game.active_player.hand

  until hand.empty?
    game.play(hand.first)
  end

  game.attack(game.passive_player) if game.active_turn.combat.positive?
  game.end_turn
end
```

There's a very early game client and server under development [here](https://github.com/tonywok/realms-world).

If you'd like to learn more about the underlying concepts and how to script the game, head over to the [wiki](https://github.com/tonywok/realms/wiki)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tonywok/realms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

This is an implementation of the game Star Realms, which was created by [White Wizard Games](http://www.whitewizardgames.com). While the code conforms to the MIT license, any intellectual property, of which I've made an effort to include none of, falls under their copyright.
