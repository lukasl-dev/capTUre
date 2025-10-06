const Channel = @This();

name: []const u8,
url: []const u8,
aliases: []const []const u8,

pub const common: []const Channel = &.{
    .{
        .name = "HS7 Schuette-Lihotzky-BI",
        .url = "https://live.video.tuwien.ac.at/lt-live/aheg07-hs-7-schuette-lihotzky-bi/playlist.m3u8",
        .aliases = &.{
            "aheg07-hs-7-schuette-lihotzky-bi",
            "hs7",
            "aheg07",
        },
    },
    .{
        .name = "HS8 Heinz-Parkus",
        .url = "https://live.video.tuwien.ac.at/lt-live/ae0141-hs-8-heinz-parkus/playlist.m3u8",
        .aliases = &.{
            "ae0141-hs-8-heinz-parkus",
            "hs8",
            "ae0141",
        },
    },
    .{
        .name = "HS13 Ernst-Melan",
        .url = "https://live.video.tuwien.ac.at/lt-live/ae0239-hs-13-ernst-melan/playlist.m3u8",
        .aliases = &.{
            "ae0239-hs-13-ernst-melan",
            "hs13",
            "ae0239",
        },
    },
    .{
        .name = "HS17 Friedrich-Hartmann",
        .url = "https://live.video.tuwien.ac.at/lt-live/ae0341-hs-17-friedrich-hartmann/playlist.m3u8",
        .aliases = &.{
            "ae0341-hs-17-friedrich-hartmann",
            "hs17",
            "ae0341",
        },
    },
    .{
        .name = "HS18 Czuber",
        .url = "https://live.video.tuwien.ac.at/lt-live/ae0238-hs-18-czuber/playlist.m3u8",
        .aliases = &.{
            "ae0238-hs-18-czuber",
            "hs18",
            "ae0238",
        },
    },
    .{
        .name = "Hoersaal-6",
        .url = "https://live.video.tuwien.ac.at/lt-live/aeeg40-hoersaal-6/playlist.m3u8",
        .aliases = &.{
            "aeeg40-hoersaal-6",
            "hoersaal-6",
            "aeeg40",
        },
    },
    .{
        .name = "GM1 Audi-Max",
        .url = "https://live.video.tuwien.ac.at/lt-live/bau178a-gm-1-audi-max/playlist.m3u8",
        .aliases = &.{
            "bau178a-gm-1-audi-max",
            "gm1",
            "bau178a",
        },
    },
    .{
        .name = "GM2 Radinger-Hoersaal",
        .url = "https://live.video.tuwien.ac.at/lt-live/bd01b33-gm-2-radinger-hoersaal/playlist.m3u8",
        .aliases = &.{
            "bd01b33-gm-2-radinger-hoersaal",
            "gm2",
            "bd01b33",
        },
    },
    .{
        .name = "GM3 Vortmann-Hoersaal",
        .url = "https://live.video.tuwien.ac.at/lt-live/ba02a05-gm-3-vortmann-hoersaal/playlist.m3u8",
        .aliases = &.{
            "ba02a05-gm-3-vortmann-hoersaal",
            "gm3",
            "ba02a05",
        },
    },
    .{
        .name = "GM4 Knoller-Hoersaal",
        .url = "https://live.video.tuwien.ac.at/lt-live/bd02d32-gm-4-knoller-hoersaal/playlist.m3u8",
        .aliases = &.{
            "bd02d32-gm-4-knoller-hoersaal",
            "gm4",
            "bd02d32",
        },
    },
    .{
        .name = "GM5 Praktikum-HS",
        .url = "https://live.video.tuwien.ac.at/lt-live/bau276a-gm-5-praktikum-hs/playlist.m3u8",
        .aliases = &.{
            "bau276a-gm-5-praktikum-hs",
            "gm5",
            "bau276a",
        },
    },
    .{
        .name = "EI7 Hoersaal",
        .url = "https://live.video.tuwien.ac.at/lt-live/cdeg13-ei-7-hoersaal/playlist.m3u8",
        .aliases = &.{
            "cdeg13-ei-7-hoersaal",
            "ei7",
            "cdeg13",
        },
    },
    .{
        .name = "EI8 Poetzl-HS",
        .url = "https://live.video.tuwien.ac.at/lt-live/cdeg08-ei-8-poetzl-hs/playlist.m3u8",
        .aliases = &.{
            "cdeg08-ei-8-poetzl-hs",
            "ei8",
            "cdeg08",
        },
    },
    .{
        .name = "EI9 Hlawka-HS",
        .url = "https://live.video.tuwien.ac.at/lt-live/caeg17-ei-9-hlawka-hs/playlist.m3u8",
        .aliases = &.{
            "caeg17-ei-9-hlawka-hs",
            "ei9",
            "caeg17",
        },
    },
    .{
        .name = "EI10 Fritz-Paschke-HS",
        .url = "https://live.video.tuwien.ac.at/lt-live/caeg31-ei-10-fritz-paschke-hs/playlist.m3u8",
        .aliases = &.{
            "caeg31-ei-10-fritz-paschke-hs",
            "ei10",
            "caeg31",
        },
    },
    .{
        .name = "FH Hoersaal-1",
        .url = "https://live.video.tuwien.ac.at/lt-live/dc02h03-fh-hoersaal-1/playlist.m3u8",
        .aliases = &.{
            "dc02h03-fh-hoersaal-1",
            "fh1",
            "dc02h03",
        },
    },
    .{
        .name = "FH Hoersaal-5",
        .url = "https://live.video.tuwien.ac.at/lt-live/da02g15-fh-hoersaal-5/playlist.m3u8",
        .aliases = &.{
            "da02g15-fh-hoersaal-5",
            "fh5",
            "da02g15",
        },
    },
    .{
        .name = "FH Hoersaal-6",
        .url = "https://live.video.tuwien.ac.at/lt-live/da02k01-fh-hoersaal-6/playlist.m3u8",
        .aliases = &.{
            "da02k01-fh-hoersaal-6",
            "fh6",
            "da02k01",
        },
    },
    .{
        .name = "FH8 Noebauer-HS",
        .url = "https://live.video.tuwien.ac.at/lt-live/db02h12-fh-8-noebauer-hs/playlist.m3u8",
        .aliases = &.{
            "db02h12-fh-8-noebauer-hs",
            "fh8",
            "db02h12",
        },
    },
    .{
        .name = "Sem-R DA-gruen-02-A",
        .url = "https://live.video.tuwien.ac.at/lt-live/da02e08-sem-r-da-gruen-02-a/playlist.m3u8",
        .aliases = &.{
            "da02e08-sem-r-da-gruen-02-a",
            "da-gruen-02-a",
            "da02e08",
        },
    },
    .{
        .name = "Sem-R DA-gruen-02-C",
        .url = "https://live.video.tuwien.ac.at/lt-live/da02f20-sem-r-da-gruen-02-c/playlist.m3u8",
        .aliases = &.{
            "da02f20-sem-r-da-gruen-02-c",
            "da-gruen-02-c",
            "da02f20",
        },
    },
    .{
        .name = "Informatikhoersaal",
        .url = "https://live.video.tuwien.ac.at/lt-live/deu116-informatikhoersaal/playlist.m3u8",
        .aliases = &.{
            "deu116-informatikhoersaal",
            "informatikhoersaal",
            "deu116",
        },
    },
    .{
        .name = "Seminarraumfav 01-a",
        .url = "https://live.video.tuwien.ac.at/lt-live/he0102-seminarraum-fav-01-a/playlist.m3u8",
        .aliases = &.{
            "he0102-seminarraum-fav-01-a",
            "seminarraumfav-01-a",
            "he0102",
        },
    },
    .{
        .name = "FAV Hoersaal-1",
        .url = "https://live.video.tuwien.ac.at/lt-live/heeg02-fav-hoersaal-1/playlist.m3u8",
        .aliases = &.{
            "heeg02-fav-hoersaal-1",
            "fav-hoersaal-1",
            "heeg02",
        },
    },
    .{
        .name = "HS Atrium-1",
        .url = "https://live.video.tuwien.ac.at/lt-live/ozeg80-hs-atrium-1/playlist.m3u8",
        .aliases = &.{
            "ozeg80-hs-atrium-1",
            "hs-atrium-1",
            "ozeg80",
        },
    },
    .{
        .name = "HS Atrium-2",
        .url = "https://live.video.tuwien.ac.at/lt-live/ozeg76-hs-atrium-2/playlist.m3u8",
        .aliases = &.{
            "ozeg76-hs-atrium-2",
            "hs-atrium-2",
            "ozeg76",
        },
    },
    .{
        .name = "Seminarraum BA 02A",
        .url = "https://live.video.tuwien.ac.at/lt-live/ba02g02-seminarraum-ba-02a/playlist.m3u8",
        .aliases = &.{
            "ba02g02-seminarraum-ba-02a",
            "seminarraum-ba-02a",
            "ba02g02",
        },
    },
    .{
        .name = "Seminarraum BA 02B",
        .url = "https://live.video.tuwien.ac.at/lt-live/ba02a17-seminarraum-ba-02b/playlist.m3u8",
        .aliases = &.{
            "ba02a17-seminarraum-ba-02b",
            "seminarraum-ba-02b",
            "ba02a17",
        },
    },
};
