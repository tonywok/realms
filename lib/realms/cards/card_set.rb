# module Realms
#   module Sets
#     class AbilityProxy
#       attr_reader :attributes
#
#       def initialize
#         @attributes = {}
#         @attributes[:actions] = []
#       end
#
#       def attack(num)
#         @attributes[:actions] << Actions::Attack.new(num)
#       end
#
#       def authority(num)
#         @attributes[:actions] << Actions::Authority.new(num)
#       end
#
#       def trade(num)
#         @attributes[:actions] << Actions::Trade.new(num)
#       end
#
#       def draw(num=1)
#         @attributes[:actions] << Actions::Draw.new(num)
#       end
#
#       def optional(&block)
#         action_proxy = AbilityProxy.new
#         action_proxy.instance_eval(&block)
#         @attributes[:actions] << Actions::Optional.new(action_proxy.attributes[:actions])
#       end
#     end
#
#     class CardProxy
#       attr_reader :attributes
#
#       def initialize(name)
#         @attributes = {}
#         attributes[:name] = name
#       end
#
#       def faction(faction)
#         attributes[:faction] = faction
#       end
#
#       def cost(num)
#         attributes[:cost] = num
#       end
#
#       def primary_ability(&block)
#         ability_proxy = AbilityProxy.new
#         ability_proxy.instance_eval(&block)
#         attributes[:primary_ability] = Abilities::Primary.new(ability_proxy.attributes)
#       end
#
#       def ally_ability(&block)
#         ability_proxy = AbilityProxy.new
#         ability_proxy.instance_eval(&block)
#         attributes[:ally_ability] = Abilities::Ally.new(ability_proxy.attributes)
#       end
#
#       def scrap_ability(&block)
#         ability_proxy = AbilityProxy.new
#         ability_proxy.instance_eval(&block)
#         attributes[:scrap_ability] = Abilities::Scrap.new(ability_proxy.attributes)
#       end
#     end
#
#     class SetProxy
#       attr_reader :card_set
#
#       def initialize(card_set)
#         @card_set = card_set
#       end
#
#       def card(name, attrs={}, &block)
#         card_proxy = CardProxy.new(name)
#         card_proxy.instance_eval(&block)
#         card_set.cards[name] = Card.new(attrs.merge(card_proxy.attributes))
#       end
#
#       def ship(name, &block)
#         card(name, { type: :ship }, &block)
#       end
#     end
#
#     class CardSet
#       @registry = {}
#
#       def self.registry
#         @registry
#       end
#
#       def self.set(name, &block)
#         card_set = CardSet.new(name)
#         proxy = SetProxy.new(card_set)
#         proxy.instance_eval(&block)
#         registry[name] = card_set
#       end
#
#       attr_reader :name, :cards
#
#       def initialize(name)
#         @name = name
#         @cards = {}
#       end
#     end
#   end
# end
