package de.awi.tournamentsimulator.worldcup2022;

import java.util.Random;

public class Util {
    // cut off abilities below this value
    public static final double ABILITY_CUTOFF = 0.01;

    public static final String CSV_SEPARATOR = ";";

    public static final int N_SIMULATIONS = 100000;
    public static final int N_ITERATIONS = 500;
    public static final double TARGET_RELATIVE_ERROR = 0.002; // 181 iterations

    static boolean isFirstTeamWinner(final Team team1, final Team team2, final Random random) {
        final double prob = calcProb(team1.ability, team2.ability);
        return random.nextDouble() < prob;
    }

    private static double calcProb(final double ability1, final double ability2) {
        return ability1 / (ability1 + ability2);
    }

    static Team calcWinner(final Team team1, final Team team2, final Random random) {
        if (isFirstTeamWinner(team1, team2, random)) {
            return team1;
        }
        else {
            return team2;
        }
    }
}
