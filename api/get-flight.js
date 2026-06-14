export default async function handler(req, res) {
  const { flight } = req.query;

  if (!flight) {
    return res.status(400).json({ error: 'Missing flight parameter' });
  }

  const CLIENT_ID = 'tornqvisteliaz@gmail.com-api-client';
  const CLIENT_SECRET = 'kAoe9RbEI7sbIdXp8I0zHQvR9iUZmmzx';

  try {
    // Get OAuth2 token
    const tokenResponse = await fetch(
      'https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token',
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          grant_type: 'client_credentials',
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
        }),
      }
    );

    if (!tokenResponse.ok) throw new Error('Failed to authenticate with OpenSky');

    const tokenData = await tokenResponse.json();
    const accessToken = tokenData.access_token;

    // Fetch current states
    const statesResponse = await fetch('https://opensky-network.org/api/states/all', {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    if (!statesResponse.ok) throw new Error('Failed to fetch states');

    const statesData = await statesResponse.json();
    const states = statesData.states || [];

    // Find matching callsign
    const searchTerm = flight.toUpperCase();
    const matching = states.filter(s => s[1] && s[1].toUpperCase().includes(searchTerm));

    if (matching.length === 0) {
      return res.status(404).json({ error: 'No live flight found' });
    }

    const state = matching[0];

    const result = {
      flightNumber: flight.toUpperCase(),
      callsign: state[1],
      icao24: state[0],
      latitude: state[6],
      longitude: state[5],
      altitude: state[7] || state[13],
      speed: state[9] ? Math.round(state[9] * 3.6) : null,
      heading: state[10],
      verticalRate: state[11],
      status: state[8] ? 'ON GROUND' : 'AIRBORNE',
    };

    return res.status(200).json(result);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}