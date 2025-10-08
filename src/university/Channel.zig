const std = @import("std");
const Channel = @This();

name: []const u8,
url: []const u8,
aliases: []const []const u8,

pub const common: []const Channel = &.{
    .{
        .name = "HS7 Schuette-Lihotzky-BI",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/aheg07-hs-7-schuette-lihotzky-bi/playlist.m3u8",
        .aliases = &.{
            "aheg07-hs-7-schuette-lihotzky-bi",
            "hs7",
            "aheg07",
            "schuette-lihotzky",
            "schuette",
        },
    },
    .{
        .name = "HS8 Heinz-Parkus",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ae0141-hs-8-heinz-parkus/playlist.m3u8",
        .aliases = &.{
            "ae0141-hs-8-heinz-parkus",
            "hs8",
            "ae0141",
            "heinz-parkus",
            "parkus",
        },
    },
    .{
        .name = "HS13 Ernst-Melan",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ae0239-hs-13-ernst-melan/playlist.m3u8",
        .aliases = &.{
            "ae0239-hs-13-ernst-melan",
            "hs13",
            "ae0239",
            "ernst-melan",
            "melan",
        },
    },
    .{
        .name = "HS17 Friedrich-Hartmann",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ae0341-hs-17-friedrich-hartmann/playlist.m3u8",
        .aliases = &.{
            "ae0341-hs-17-friedrich-hartmann",
            "hs17",
            "ae0341",
            "friedrich-hartmann",
            "hartmann",
        },
    },
    .{
        .name = "HS18 Czuber",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ae0238-hs-18-czuber/playlist.m3u8",
        .aliases = &.{
            "ae0238-hs-18-czuber",
            "hs18",
            "ae0238",
            "czuber",
        },
    },
    .{
        .name = "Hoersaal-6",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/aeeg40-hoersaal-6/playlist.m3u8",
        .aliases = &.{
            "aeeg40-hoersaal-6",
            "hoersaal-6",
            "aeeg40",
            "hoersaal6",
            "hs6",
        },
    },
    .{
        .name = "GM1 Audi-Max",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/bau178a-gm-1-audi-max/playlist.m3u8",
        .aliases = &.{
            "bau178a-gm-1-audi-max",
            "gm1",
            "bau178a",
            "audimax",
            "gm-1",
            "audi-max",
        },
    },
    .{
        .name = "GM2 Radinger-Hoersaal",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/bd01b33-gm-2-radinger-hoersaal/playlist.m3u8",
        .aliases = &.{
            "bd01b33-gm-2-radinger-hoersaal",
            "gm2",
            "bd01b33",
            "gm-2",
            "radinger",
        },
    },
    .{
        .name = "GM3 Vortmann-Hoersaal",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ba02a05-gm-3-vortmann-hoersaal/playlist.m3u8",
        .aliases = &.{
            "ba02a05-gm-3-vortmann-hoersaal",
            "gm3",
            "ba02a05",
            "gm-3",
            "vortmann",
        },
    },
    .{
        .name = "GM4 Knoller-Hoersaal",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/bd02d32-gm-4-knoller-hoersaal/playlist.m3u8",
        .aliases = &.{
            "bd02d32-gm-4-knoller-hoersaal",
            "gm4",
            "bd02d32",
            "gm-4",
            "knoller",
        },
    },
    .{
        .name = "GM5 Praktikum-HS",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/bau276a-gm-5-praktikum-hs/playlist.m3u8",
        .aliases = &.{
            "bau276a-gm-5-praktikum-hs",
            "gm5",
            "bau276a",
            "gm-5",
            "praktikum",
        },
    },
    .{
        .name = "EI7 Hoersaal",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/cdeg13-ei-7-hoersaal/playlist.m3u8",
        .aliases = &.{
            "cdeg13-ei-7-hoersaal",
            "ei7",
            "cdeg13",
            "ei-7",
        },
    },
    .{
        .name = "EI8 Poetzl-HS",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/cdeg08-ei-8-poetzl-hs/playlist.m3u8",
        .aliases = &.{
            "cdeg08-ei-8-poetzl-hs",
            "ei8",
            "cdeg08",
            "ei-8",
            "poetzl",
        },
    },
    .{
        .name = "EI9 Hlawka-HS",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/caeg17-ei-9-hlawka-hs/playlist.m3u8",
        .aliases = &.{
            "caeg17-ei-9-hlawka-hs",
            "ei9",
            "caeg17",
            "ei-9",
            "hlawka",
        },
    },
    .{
        .name = "EI10 Fritz-Paschke-HS",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/caeg31-ei-10-fritz-paschke-hs/playlist.m3u8",
        .aliases = &.{
            "caeg31-ei-10-fritz-paschke-hs",
            "ei10",
            "caeg31",
            "ei-10",
            "fritz-paschke",
        },
    },
    .{
        .name = "FH Hoersaal-1",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/dc02h03-fh-hoersaal-1/playlist.m3u8",
        .aliases = &.{
            "dc02h03-fh-hoersaal-1",
            "fh1",
            "dc02h03",
            "fh-hoersaal-1",
        },
    },
    .{
        .name = "FH Hoersaal-5",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/da02g15-fh-hoersaal-5/playlist.m3u8",
        .aliases = &.{
            "da02g15-fh-hoersaal-5",
            "fh5",
            "da02g15",
            "fh-hoersaal-5",
        },
    },
    .{
        .name = "FH Hoersaal-6",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/da02k01-fh-hoersaal-6/playlist.m3u8",
        .aliases = &.{
            "da02k01-fh-hoersaal-6",
            "fh6",
            "da02k01",
            "fh-hoersaal-6",
        },
    },
    .{
        .name = "FH8 Noebauer-HS",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/db02h12-fh-8-noebauer-hs/playlist.m3u8",
        .aliases = &.{
            "db02h12-fh-8-noebauer-hs",
            "fh8",
            "db02h12",
            "fh-8",
            "noebauer",
        },
    },
    .{
        .name = "Sem-R DA-gruen-02-A",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/da02e08-sem-r-da-gruen-02-a/playlist.m3u8",
        .aliases = &.{
            "da02e08-sem-r-da-gruen-02-a",
            "da-gruen-02-a",
            "da02e08",
            "dagruen02a",
        },
    },
    .{
        .name = "Sem-R DA-gruen-02-C",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/da02f20-sem-r-da-gruen-02-c/playlist.m3u8",
        .aliases = &.{
            "da02f20-sem-r-da-gruen-02-c",
            "da-gruen-02-c",
            "da02f20",
            "dagruen02c",
        },
    },
    .{
        .name = "Informatikhoersaal",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/deu116-informatikhoersaal/playlist.m3u8",
        .aliases = &.{
            "deu116-informatikhoersaal",
            "informatikhoersaal",
            "deu116",
            "informatik-hoersaal",
        },
    },
    .{
        .name = "Seminarraumfav 01-a",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/he0102-seminarraum-fav-01-a/playlist.m3u8",
        .aliases = &.{
            "he0102-seminarraum-fav-01-a",
            "seminarraumfav-01-a",
            "he0102",
            "fav01a",
            "seminarraum-fav-01-a",
        },
    },
    .{
        .name = "FAV Hoersaal-1",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/heeg02-fav-hoersaal-1/playlist.m3u8",
        .aliases = &.{
            "heeg02-fav-hoersaal-1",
            "fav-hoersaal-1",
            "heeg02",
            "fav1",
            "fav-hs-1",
        },
    },
    .{
        .name = "HS Atrium-1",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ozeg80-hs-atrium-1/playlist.m3u8",
        .aliases = &.{
            "ozeg80-hs-atrium-1",
            "hs-atrium-1",
            "ozeg80",
            "hs-atrium1",
            "atrium-1",
        },
    },
    .{
        .name = "HS Atrium-2",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ozeg76-hs-atrium-2/playlist.m3u8",
        .aliases = &.{
            "ozeg76-hs-atrium-2",
            "hs-atrium-2",
            "ozeg76",
            "hs-atrium2",
            "atrium-2",
        },
    },
    .{
        .name = "Seminarraum BA 02A",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ba02g02-seminarraum-ba-02a/playlist.m3u8",
        .aliases = &.{
            "ba02g02-seminarraum-ba-02a",
            "seminarraum-ba-02a",
            "ba02g02",
            "ba-02a",
            "seminarraum-ba02a",
        },
    },
    .{
        .name = "Seminarraum BA 02B",
        .url = "https://live-cdn-2.video.tuwien.ac.at/lecturetube-live/ba02a17-seminarraum-ba-02b/playlist.m3u8",
        .aliases = &.{
            "ba02a17-seminarraum-ba-02b",
            "seminarraum-ba-02b",
            "ba02a17",
            "ba-02b",
            "seminarraum-ba02b",
        },
    },
};

pub fn find(query: []const u8) ?Channel {
    const trimmed = std.mem.trim(u8, query, " \t\r\n");
    if (trimmed.len == 0) return null;

    for (common) |channel| {
        if (std.ascii.eqlIgnoreCase(trimmed, channel.name)) {
            return channel;
        }
        if (std.mem.eql(u8, trimmed, channel.url)) {
            return channel;
        }
        for (channel.aliases) |alias| {
            if (std.ascii.eqlIgnoreCase(trimmed, alias)) {
                return channel;
            }
        }
    }

    return null;
}

pub const ResolveError = error{UnknownChannel};
pub fn resolve(query: []const u8) ResolveError![]const u8 {
    const trimmed = std.mem.trim(u8, query, " \t\r\n");
    if (trimmed.len == 0) return error.UnknownChannel;

    if (std.Uri.parse(trimmed) catch null) |_| {
        return trimmed;
    }

    if (find(trimmed)) |channel| {
        return channel.url;
    }

    return error.UnknownChannel;
}
