import { Button, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  admin: AdminData[];
  player: PlayerData[];
};

type AdminData = {
  name: string;
  feedback_link: string;
  rank: String;
  ignored: BooleanLike;
};

type PlayerData = {
  name: string;
  ignored: BooleanLike;
};

export const PlayerList = (props) => {
  const { act, data } = useBackend<Data>();
  const { admin = [], player = [] } = data;
  return (
    <Window width={420} height={415}>
      <Window.Content>
        <Stack vertical fill style={{ overflowY: 'auto' }}>
          <Section align="center" title="Admins">
            {admin.map((individual_admin) => (
              <Stack.Item key={individual_admin.name}>
                <Button
                  mx={1}
                  color={individual_admin.ignored ? 'red' : 'green'}
                  tooltip={
                    individual_admin.ignored
                      ? 'Click to Unignore'
                      : 'Click to Ignore'
                  }
                  onClick={() =>
                    act('ignore', {
                      name: individual_admin.name,
                    })
                  }
                >
                  {individual_admin.name}
                </Button>
                is a {individual_admin.rank}
                {individual_admin.feedback_link && (
                  <Button
                    onClick={() =>
                      act('feedback_link', {
                        link: individual_admin.feedback_link,
                      })
                    }
                  >
                    Feedback
                  </Button>
                )}
              </Stack.Item>
            ))}
          </Section>
          <Section align="center" title="Players">
            {player.map((individual_player) => (
              <Stack.Item key={individual_player.name}>
                <Button
                  color={individual_player.ignored ? 'red' : 'green'}
                  tooltip={
                    individual_player.ignored
                      ? 'Click to Unignore'
                      : 'Click to Ignore'
                  }
                >
                  {individual_player.name}
                </Button>
              </Stack.Item>
            ))}
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
