package de.awi.tournamentsimulator.worldcup2022;

import java.util.Objects;

public class GroupStageResult {
    Team first;
    Team second;
    Team third;
    Team fourth;

    public GroupStageResult(final Team first, final Team second, final Team third, final Team fourth) {
        this.first = first;
        this.second = second;
        this.third = third;
        this.fourth = fourth;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final GroupStageResult that = (GroupStageResult) o;
        return Objects.equals(first, that.first) &&
                Objects.equals(second, that.second) &&
                Objects.equals(third, that.third) &&
                Objects.equals(fourth, that.fourth);
    }

    @Override
    public int hashCode() {

        return Objects.hash(first, second, third, fourth);
    }
}
