CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusId" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "createDate" TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY("statusId")
);
