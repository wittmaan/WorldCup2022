package de.awi.tournamentsimulator.worldcup2022;

public class KnockoutStageRound {
    final String name;
    Integer count;

    public KnockoutStageRound(String name) {
        this.name = name;
        this.count = 0;
    }

    @Override
    public String toString() {
        return "KnockoutStageRound{" +
                "name='" + name + '\'' +
                ", count=" + count +
                '}';
    }
}
