keymaps = {}

function keymaps.init()

    input = baton.new{
        controls ={
            moveleft = {'key:kp4', 'key:a'},
            moveright = {'key:kp6', 'key:d'},
            moveforward = {'key:kp8', 'key:w'},
            movebackwards = {'key:kp2', 'key:s'},
            rotateleft = {'key:kp7', 'key:q'},
            rotateright = {'key:kp9', 'key:e'},
            centreview = {'key:kp5', 'key:c'}
    }
}

end

return keymaps
