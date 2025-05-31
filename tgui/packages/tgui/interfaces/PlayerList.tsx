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
        <Section scrollable fill>
          <Stack vertical>
            <Section align="center" title="Admins">
              {admin.length === 0 ? (
                <Stack.Item grow>No Admins online!</Stack.Item>
              ) : (
                <Stack.Item>
                  {admin.map((individual_admin) => (
                    <Stack.Item my={1} grow key={individual_admin.name}>
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
                </Stack.Item>
              )}
            </Section>
            <Section align="center" title="Players">
              {player.map((individual_player) => (
                <Button
                  key={individual_player.name}
                  color={individual_player.ignored ? 'red' : 'green'}
                  tooltip={
                    individual_player.ignored
                      ? 'Click to Unignore'
                      : 'Click to Ignore'
                  }
                >
                  {individual_player.name}
                </Button>
              ))}
            </Section>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
