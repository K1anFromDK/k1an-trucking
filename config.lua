Config = {}

Config.Debug = false -- hvis true så bliver alle markersne omringet af en rød box. Ved ikke hvorfor at når du bruger debug mode så spiker ms'en lige med omkring 0.07 ms.

Config.TrailerModel = 'trailers4' -- spawn koden til traileren

Config.MinMaxSupplies = { -- hvor mange supply locationer du kan få per gang. Hver dog lige ops på at hvis der er fx 2 supply locations og du har sat max til 3 så kommer den nok til at stacke dem!
    min = 1,
    max = 3
}

Config.Rewards = { -- min og max på hvor meget du kan tjene per job.
    min = 1000,
    max = 5000
}

Config.PickupLocations = { -- pick up lokationer hvor du henter trailere
    {
        name = 'Trucker John',
        npcxyz = vec4(-643.3914, -1227.8879, 11.5476, 301.1554),
        trailerxyz = vec4(-632.7674, -1215.6549, 12.4707, 314.0682)
    },
    {
        name = 'Trucker Bob',
        npcxyz = vec4(-696.1695, -1386.7291, 5.4953, 50.6014),
        trailerxyz = vec4(-709.4367, -1404.9750, 5.0005, 49.7949)
    },
    {
        name = 'Trucker Joe',
        npcxyz = vec4(-1742.6917, 3312.9641, 41.2235, 121.2045),
        trailerxyz = vec4(1732.7784, 3308.2417, 41.2235, 191.7054)
    }
}

Config.RandomDeliveryLocations = { -- leverings lokationer
    [1] = vec3(-801.7617, -1331.3763, 5.0004),
    [2] = vec3(1419.7765, 3622.4839, 34.8662),
    [3] = vec3(890.9039, 3652.2285, 32.8197),
    [4] = vec3(339.3763, 3417.4250, 36.5078),
    [5] = vec3(-801.3808, 5408.3701, 33.8750),
    [6] = vec3(-267.1897, 6055.0938, 31.5921),
    [7] = vec3(19.6813, 6279.4731, 31.2616),
    [8] = vec3(2481.8164, 4116.3042, 38.0578),
    [9] = vec3(2692.2998, 3443.5862, 55.8259),
    [10] = vec3(1859.0304, 2559.6108, 45.6676)
}

Config.SupplyLocations = { -- lokationerne hvor du henter varer
    [1] = vec3(-22.0118, -2673.3350, 6.0025),
    [2] = vec3(-526.0204, -2832.5989, 6.0004),
    [3] = vec3(-1003.7262, -2369.2576, 13.9396),
    [4] = vec3(-809.5883, -1328.9037, 4.9909),
    [5] = vec3(705.6165, 245.5919, 92.9628)
} 

Config.Notify = function(type, message, duration) -- notify funktion
    if not IsDuplicityVersion() then -- client notify / bliver brugt i hele clienten så ændre til jeres ejet
        lib.notify({
            type = type,
            description = message,
            duration = duration
        })
    else -- server notify / bliver ikke brugt alligevel så er lidt ligegyldigt
        print(message)
    end
end