/// obj_friends - Create Event

depth = -10000; // draw above everything, including a chip being dragged

// The click that opened this panel can still be "pressed" on the first
// frame, and would land on whatever sits under the cursor. Ignore clicks
// for the first couple of frames.
ignore_clicks = 2;

// ---------- Placeholder data ----------
// Stored in a global so removals survive closing and reopening the panel.
// TODO (backend teammate): replace this with the real friends list from
// Supabase. Keep the same shape: an array of structs with id, name, xp.
// "id" is what the real remove call needs to delete the right row.
if (!variable_global_exists("friends")) {
    global.friends = [
        { id: "placeholder-1", name: "PixelPete", xp: 120 },
        { id: "placeholder-2", name: "CodeCat",   xp: 85  },
        { id: "placeholder-3", name: "ByteMe",     xp: 240 },
        { id: "placeholder-4", name: "NullPtr",    xp: 15  },
        { id: "placeholder-5", name: "LoopLord",   xp: 330 },
        { id: "placeholder-6", name: "SyntaxSam",  xp: 60  },
        { id: "placeholder-7", name: "BugHunter",  xp: 410 },
        { id: "placeholder-8", name: "StackOver",  xp: 175 }
    ];
}

// ---------- State ----------
confirm_index = -1; // row waiting on its second "SURE?" click
scroll        = 0;  // index of the first visible row

// ---------- Layout (computed from the room, not hardcoded) ----------
panel_w = min(room_width  - 16, 236);
panel_h = min(room_height - 16, 224);
panel_x = (room_width  - panel_w) / 2;
panel_y = (room_height - panel_h) / 2;

row_height = 22;
row_gap    = 4;
remove_w   = 56;

list_x = panel_x + 8;
list_w = panel_w - 16;
list_y = panel_y + 26;

close_w  = 80;
close_h  = 18;
close_x1 = (room_width - close_w) / 2;
close_y1 = panel_y + panel_h - close_h - 8;
close_x2 = close_x1 + close_w;
close_y2 = close_y1 + close_h;

// How many rows fit between the title and the close button
visible_rows = max(1, floor((close_y1 - 6 - list_y + row_gap) / (row_height + row_gap)));