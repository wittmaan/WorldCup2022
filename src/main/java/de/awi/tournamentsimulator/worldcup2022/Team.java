package de.awi.tournamentsimulator.worldcup2022;

import java.util.Objects;

public class Team {
    final String name;
    final String group;
    Double ability;
    final Double probability;

    GroupStage groupStage = new GroupStage(0);
    KnockoutStage knockoutStage = new KnockoutStage();

    public Team(final String name, final String group, final Double ability, final Double probability) {
        this.name = name;
        this.group = group;
        this.ability = ability;
        this.probability = probability;
    }

    @Override
    public String toString() {
        return "Team{" +
                "name='" + name + '\'' +
                ", group='" + group + '\'' +
                ", ability=" + ability +
                ", probability=" + probability +
                ", groupStage=" + groupStage +
                ", knockoutStage=" + knockoutStage +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final Team team = (Team) o;
        return Objects.equals(name, team.name) &&
                Objects.equals(group, team.group);
    }

    @Override
    public int hashCode() {

        return Objects.hash(name, group);
    }
}
