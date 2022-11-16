package de.awi.tournamentsimulator.worldcup2022;

import java.util.Objects;

public class KnockoutStageMatch {
    Team team1;
    Team team2;

    public KnockoutStageMatch(final Team team1, final Team team2) {
        this.team1 = team1;
        this.team2 = team2;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final KnockoutStageMatch match = (KnockoutStageMatch) o;
        return Objects.equals(team1, match.team1) &&
                Objects.equals(team2, match.team2);
    }

    @Override
    public int hashCode() {

        return Objects.hash(team1, team2);
    }
}
