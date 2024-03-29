permissionset 66000 "EAI Admin Lib"
{
    Assignable = true;
    Permissions = tabledata "EAI Entities" = RIMD,
        tabledata "EAI Intent Selection Temporary" = RIMD,
        tabledata "EAI Library Setup" = RIMD,
        tabledata "EAI Utterance Worksheet" = RIMD,
        table "EAI Entities" = X,
        table "EAI Intent Selection Temporary" = X,
        table "EAI Library Setup" = X,
        table "EAI Utterance Worksheet" = X,
        codeunit "EAI Functions" = X,
        codeunit "EAI SendRequest" = X,
        page "EAI Intent Selection" = X,
        page "EAI Library Setup" = X,
        page "EAI Utterance Worksheet" = X;
}