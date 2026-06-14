let cachedToken = null;
let tokenExpiry = 0;

export default async function handler(req, res) {
  const { flight } = req.query;

  if (!flight) {
    return res.status(400).json({ error: 'Missing flight parameter' });
  }

  const CLIENT_ID = 'tornqvisteliaz@gmail.com-api-client';
  const CLIENT_SECRET = 'kAoe9RbEI7sbIdXp8I0zHQvR9iUZmmzx';
  const searchTerm = flight.toUpperCase();

  try {
    // Get or refresh token (cached ~25 min)
    const now = Date.now();
    if (!cachedToken || now > tokenExpiry) {
      const tokenRes = await fetch(
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

      if (!tokenRes.ok) throw new Error('OpenSky authentication failed');

      const tokenData = await tokenRes.json();
      cachedToken = tokenData.access_token;
      tokenExpiry = now + (tokenData.expires_in - 60) * 1000;
    }

    // Fetch current states
    const statesRes = await fetch('https://opensky-network.org/api/states/all', {
      headers: { Authorization: `Bearer ${cachedToken}` },
    });

    if (!statesRes.ok) throw new Error('Failed to fetch states from OpenSky');

    const statesData = await statesRes.json();
    const states = statesData.states || [];

    // Find best match (exact callsign first, then contains)
    let match = states.find(s => s[1] && s[1].toUpperCase() === searchTerm);
    if (!match) {
      match = states.find(s => s[1] && s[1].toUpperCase().includes(searchTerm));
    }

    if (!match) {
      return res.status(404).json({
        error: 'No live flight found',
        flight: flight,
      });
    }

    // Map OpenSky state vector
    const result = {
      flightNumber: flight.toUpperCase(),
      callsign: match[1]?.trim() || flight,
      icao24: match[0],
      latitude: match[6],
      longitude: match[5],
      altitude: match[7] ?? match[13],
      speed: match[9] ? Math.round(match[9] * 3.6) : null,
      heading: match[10],
      verticalRate: match[11],
      onGround: match[8] === true,
      lastContact: match[4],
      status: match[8] ? 'ON GROUND' : 'AIRBORNE',
      origin: null,
      destination: null,
    };

    return res.status(200).json(result);
  } catch (error) {
    console.error('OpenSky error:', error);
    return res.status(500).json({ error: error.message });
  }
}