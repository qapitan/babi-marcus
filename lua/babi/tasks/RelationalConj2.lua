-- Copyright (c) 2015-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.

local List = require "pl.List"

local babi = require "babi"
local actions = require "babi.actions"
local utilities = require "babi.utilities"

local RelationalConj2 = torch.class("babi.RelationalConj2", "babi.Task", babi)

function RelationalConj2:new_world()
    local world = babi.World()
    world:load((BABI_HOME or "") .. "tasks/worlds/world_basic.txt")
    return world
end

function RelationalConj2:generate_story(world, knowledge, story)
    -- Find the actors and the locations in the world
    local actors = world:get_actors()
    local locations = world:get_locations()

    -- Our story will be 2 statements, 1 question, 5 times
    for i = 1, 5 do
        -- Select two actors and two locations
        local clauses = List()
        local random_actors = utilities.choice(actors, 2)
        random_actors:extend(utilities.choice(actors, 2))
        local random_locations = utilities.choice(locations, 2)

        clauses:append(babi.Clause(world, true, random_actors[1],
            actions.teleport, random_locations[1]))
        clauses:append(babi.Clause(world, true, random_actors[2],
            actions.teleport, random_locations[1]))
        clauses:append(babi.Clause(world, true, random_actors[1],
            actions.teleport, random_locations[2]))
        clauses:append(babi.Clause(world, true, random_actors[2],
            actions.teleport, random_locations[2]))

        

        for _, clause in pairs(clauses) do
            clause:perform()
            knowledge:update(clause)
        end
        story:extend(clauses)

        -- Pick a random actor and ask where he/she is
        --local random_actor = random_actors[math.random(2)]

        -- Marcus code here
        -- Pick two random actors and ask where he/she is
        local random_actor1 = random_actors[math.random(4)]
        local random_actor2 = random_actors[math.random(4)]

        -- Stupid but working way of making sure the two actors are not
        -- the same
        while (random_actor2 == random_actor1) do
            random_actor2 = random_actors[math.random(4)]
        end

        local location1, support1 = knowledge:current()[random_actor1]:get_value("is_in", true)
        local location2, support2 = knowledge:current()[random_actor2]:get_value("is_in", true)
        -- Only get location?
        --local location2 = knowledge:current()[random_actor2]:get_value("is_in", false)
        local truth_value = (location1 == location2) -- Are the two actors same place?


        --normal code here
        local value, support = knowledge:current()[random_actor1]:get_value("is_in", true)

        --support:append

        story:append(
            babi.Question(
                "yes_no",
                babi.Clause(world, truth_value, world:god(), actions.set, random_actor2, "is_in", random_actor1),
                support
            )
        )
    end
    return story, knowledge
end

RelationalConj2.DEFAULT_CONFIG = {
    coreference = 1.0,
    compound = 1.0,
    conjunction = 1.0
}

return RelationalConj2
