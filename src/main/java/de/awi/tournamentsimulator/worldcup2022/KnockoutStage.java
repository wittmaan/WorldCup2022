package de.awi.tournamentsimulator.worldcup2022;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class KnockoutStage {
    final List<KnockoutStageRound> rounds = new ArrayList<>();
    Integer countWinner;

    public KnockoutStage() {
        this.countWinner = 0;
        Arrays.asList(KnockoutStageRoundName.values())
                .forEach(round -> rounds.add(new KnockoutStageRound(round.name())));
    }

    @Override
    public String toString() {
        return "KnockoutStage{" +
                "rounds=" + rounds +
                ", countWinner=" + countWinner +
                '}';
    }
}
