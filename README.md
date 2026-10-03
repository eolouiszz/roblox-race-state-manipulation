# Roblox — Race State Manipulation

Security research and proof-of-concept documentation for an apparent
server-side validation issue in **Pumma Talladega**.

The research demonstrates that certain race-related `RemoteEvents`
can be invoked from the client to manipulate the state and settings
of a race.

---

## 🎮 Tested Experience

**Game:** Pumma Talladega

**Platform:** Roblox

---

## 🔎 Finding — Unauthorized Race State Manipulation

### Classification

* **Type:** RemoteEvent Abuse
* **Category:** Race State Manipulation
* **Potential weakness:** Missing server-side authorization/validation
* **Affected functionality:** Race settings and race state
* **Severity:** Dependent on server-side implementation

---

## 🎯 Affected RemoteEvents

The following RemoteEvents were observed during testing:

```text
ReplicatedStorage.StandingsModeEvent
ReplicatedStorage.StandingsSettingsEvent
```

The client was able to invoke these events directly.

---

## 💥 Observed Behavior

The research demonstrated two relevant behaviors.

### 1. Race Lap Manipulation

The `StandingsSettingsEvent` accepts race-related settings.

During testing, the following request was accepted:

```lua
settingsRemote:FireServer("Laps", 999)
```

This attempts to change the race's lap configuration to an extremely
large value.

### 2. Race State Manipulation

The `StandingsModeEvent` accepts race-state commands.

The following request was also accepted:

```lua
modeRemote:FireServer("EndRace")
```

This attempts to immediately change the race state to `EndRace`.

---

## 🧪 Proof of Concept

```lua
local modeRemote =
    game.ReplicatedStorage:FindFirstChild("StandingsModeEvent")

local settingsRemote =
    game.ReplicatedStorage:FindFirstChild("StandingsSettingsEvent")

if settingsRemote then
    pcall(function()
        settingsRemote:FireServer("Laps", 999)

        print("[+] Race lap setting modified.")
    end)
end

if modeRemote then
    pcall(function()
        modeRemote:FireServer("EndRace")

        print("[+] EndRace request sent.")
    end)
end
```

The PoC demonstrates that the relevant RemoteEvents can be triggered
directly from the client.

---

## ⚠️ Why This Matters

Race configuration and race-state transitions are generally expected
to be controlled by trusted server-side logic.

If a normal client can directly request privileged operations such as
changing race settings or ending a race, the server should verify
whether that player is actually authorized to perform the requested
operation.

Client-side restrictions alone are insufficient because a modified
client can invoke RemoteEvents directly.

---

## 🛡️ Recommended Mitigations

The server should validate every request received through these
RemoteEvents.

Possible protections include:

* Server-side authorization checks
* Validating which players can modify race settings
* Restricting race-state transitions to trusted server logic
* Validating accepted commands
* Validating numerical values such as lap counts
* Rejecting unexpected or excessive values
* Separating administrative/race-controller actions from player actions

For example, the server could verify that the requesting player is
actually the race host or has the required permissions before
processing a command such as `EndRace`.

---

## 🧠 Research Process

The vulnerability was discovered through relatively simple client-side
testing.

The research involved:

1. Inspecting the game's accessible client-side objects.
2. Identifying race-related RemoteEvents.
3. Observing the parameters used by those events.
4. Testing whether the events could be invoked directly.
5. Testing different race-related parameters.
6. Observing the resulting race behavior.
7. Documenting the findings.

No advanced exploitation framework or custom infrastructure was required.

The main objective was understanding how the client communicates race
state and settings to the server.

---

## 📚 Research Goals

This repository is intended for educational and defensive security
research involving:

* Roblox RemoteEvents
* Client-server architecture
* Server-side authorization
* Input validation
* Race-state management
* RemoteEvent abuse
* Secure Roblox development
* Vulnerability research

---

## ⚠️ Responsible Use

This repository is provided for **educational and authorized security
research purposes only**.

Do not use the proof-of-concept to disrupt public races, interfere
with other players, or abuse systems without authorization.

### No Responsibility for Misuse

I am **not responsible or liable for actions performed by other people
using the information or code contained in this repository**.

If someone copies, modifies, or repurposes this PoC to create another
exploit, interfere with a game, disrupt a server, manipulate races,
harass players, or perform any other malicious or unauthorized action,
that person's actions are their own responsibility.

I do not authorize, encourage, or endorse malicious use of this
research.

The purpose of this repository is to document the discovery and help
developers understand and mitigate the underlying security issue.

---

## 📌 Important

The exact severity of this finding depends on the server-side
implementation.

This repository documents the observed client-to-server behavior and
does not claim that the issue constitutes a critical vulnerability,
remote code execution, or denial-of-service vulnerability.

Further impact assessment should be performed only in an authorized
testing environment.

---

## 📄 License

This repository is intended for educational and security research
purposes.

By using material from this repository, you acknowledge that you are
responsible for your own actions and for ensuring that your use
complies with applicable laws, platform rules, and the authorization
of the system being tested.
