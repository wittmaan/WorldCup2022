package de.awi.tournamentsimulator.worldcup2022;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.Random;
import java.util.stream.IntStream;

public class GroupStageCalculator {
    private final Logger log = LogManager.getLogger(GroupStageCalculator.class.getName());
    private final Random random;
    private final List<Team> teams;

    public GroupStageCalculator(List<Team> teams, Random random) {
        this.random = random;
        this.teams = teams;

        run();
    }

    private void run() {
        calcPoints(teams.get(0), teams.get(1));
        calcPoints(teams.get(2), teams.get(3));
        calcPoints(teams.get(0), teams.get(2));
        calcPoints(teams.get(3), teams.get(1));
        calcPoints(teams.get(3), teams.get(0));
        calcPoints(teams.get(1), teams.get(2));

        teams.sort((team1, team2) -> compareTeams(team1, team2));
        IntStream.rangeClosed(0,3).forEach(idx -> teams.get(idx).groupStage.standing = idx + 1);
    }

    private int compareTeams(final Team team1, final Team team2) {
        if (team1.groupStage.points < team2.groupStage.points) {
            return 1;
        }
        else if (team1.groupStage.points > team2.groupStage.points) {
            return -1;
        }
        else {
            if (Util.isFirstTeamWinner(team1, team2, random)) {
                return -1;
            }
            else {
                return 1;
            }
        }

    }

    private void calcPoints(final Team team1, final Team team2) {
        if (Util.isFirstTeamWinner(team1, team2, random)) {
            team1.groupStage.points += 3;
        }
        else {
            team2.groupStage.points += 3;
        }
    }
}
