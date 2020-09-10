Thrones::Game.structure do
  phase(:setup) do
    step(:draw_hand)
    step(:place_setup_cards)
  end

  loop(:round) do
    phase(:plot) do
      step(:choose_plots)
      step(:reveal_plots) do
        step(:compare_initiative)
        step(:choose_first_player)
        step(:initiate_when_revealed)
      end
    end

    phase(:draw) do
      step(:each_player_draws_two)
      step(:action_window)
    end

    phase(:marshaling) do
      in_player_order do
        step(:active_player_collects_income)
        step(:special_action_window)
      end
    end

    phase(:challenges) do
      step(:action_window)
      in_player_order do
        step(:initiate_challenge) do
          step(:action_window)
          step(:defenders_declared)
          step(:action_window)
          step(:determine_winner)
          step(:gain_challenge_bonuses)
          step(:apply_claim_result)
          step(:process_challenge_resolution_keywords)
        end
      end
    end

    phase(:dominance) do
      step(:determine_dominance)
      step(:action_window)
    end

    phase(:standing) do
      step(:stand_each_kneeling_card)
      step(:action_window)
    end

    phase(:taxation) do
      step(:return_unspent_gold)
      step(:discard_to_reserve)
      step(:action_window)
    end
  end
end