package de.awi.tournamentsimulator.worldcup2022;

import java.util.List;

public class AbilityAdaptor {
    private final List<Team> teams;
    private double errorSum;

    public AbilityAdaptor(final List<Team> teams) {
        this.errorSum = 0.0;
        this.teams = teams;

        teams.forEach(team -> {
            final double calculatedProbability = team.knockoutStage.countWinner.doubleValue() / Util.N_SIMULATIONS;
            final double diff = team.probability - calculatedProbability;
            team.ability += diff / 2.0;

            this.errorSum += Math.abs(team.probability - calculatedProbability);
        });
    }

    public double getRelativeError() {
        return errorSum / teams.size();
    }
}
