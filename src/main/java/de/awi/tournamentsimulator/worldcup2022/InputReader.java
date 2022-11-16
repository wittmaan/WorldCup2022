package de.awi.tournamentsimulator.worldcup2022;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class InputReader {
    private final Logger log = LogManager.getLogger(InputReader.class.getName());
    private final List<Team> teams = new ArrayList<>();

    public InputReader(File input) {
        log.info("got this input file: " + input.getName());

        fillTeams(input);
    }

    private void fillTeams(File input) {
        try (BufferedReader br = new BufferedReader(new FileReader(input))) {
            String line;
            br.readLine(); // skip header

            while ((line = br.readLine()) != null) {
                final String[] array = line.split(Util.CSV_SEPARATOR);

                final String teamName = array[0];
                final String group = array[1];
                final Double probability = Double.valueOf(array[3]);

                Double ability = Math.exp(probability);
//                if (ability < Util.ABILITY_CUTOFF) {
//                    ability = Util.ABILITY_CUTOFF;
//                }

                Team team = new Team(teamName, group, ability, probability);
                teams.add(team);
                if (log.isDebugEnabled()) {
                    log.debug("added this team: " + team);
                }
            }
        }
        catch (final Exception e) {
            log.error(e.getMessage());
        }
    }

    List<Team> getTeams() {
        return teams;
    }
}
