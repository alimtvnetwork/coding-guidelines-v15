import { useState } from "react";
import { Check, Copy, Package, Terminal } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import versionData from "@/../version.json";
import bundlesManifest from "@/../bundles.json";

type InstallCommand = {
  platform: string;
  shell: string;
  command: string;
};

const installCommands: InstallCommand[] = [
  {
    platform: "Windows",
    shell: "PowerShell",
    command: "irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1 | iex",
  },
  {
    platform: "Windows (skip latest probe)",
    shell: "PowerShell",
    command: "& ([scriptblock]::Create((irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1))) -n",
  },
  {
    platform: "macOS / Linux",
    shell: "Bash",
    command: "curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh | bash",
  },
  {
    platform: "macOS / Linux (skip latest probe)",
    shell: "Bash",
    command: "curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh | bash -s -- -n",
  },
];

type BundleCommand = {
  bundle: string;
  description: string;
  folders: string[];
  bash: string;
  ps: string;
  archiveZip: string;
  archiveTar: string;
  downloadBash: string;
  downloadPwsh: string;
};

const RAW_BASE = bundlesManifest.rawBase;
const RELEASE_BASE = bundlesManifest.releaseBase;
const LATEST_TAG = `v${versionData.version}`;

const bundleCommands: BundleCommand[] = bundlesManifest.bundles.map((b) => {
  const stable = b.archive.stableName;
  const tarUrl = `${RELEASE_BASE}/download/${LATEST_TAG}/${stable}.tar.gz`;
  const zipUrl = `${RELEASE_BASE}/download/${LATEST_TAG}/${stable}.zip`;
  return {
    bundle: b.name,
    description: b.description,
    folders: b.folders.map((f) => f.dest),
    bash: `curl -fsSL ${RAW_BASE}/${b.name}-install.sh | bash`,
    ps: `irm ${RAW_BASE}/${b.name}-install.ps1 | iex`,
    archiveZip: zipUrl,
    archiveTar: tarUrl,
    downloadBash: `curl -fsSLO ${tarUrl}`,
    downloadPwsh: `Invoke-WebRequest -Uri ${zipUrl} -OutFile ${stable}.zip`,
  };
});

function CopyButton({ command }: { command: string }) {
  const [hasCopied, setHasCopied] = useState(false);

  const handleCopy = async () => {
    await navigator.clipboard.writeText(command);
    setHasCopied(true);
    setTimeout(() => setHasCopied(false), 2000);
  };

  return (
    <Button
      size="sm"
      variant="ghost"
      onClick={handleCopy}
      className="h-8 shrink-0 px-2 text-muted-foreground hover:text-foreground"
      aria-label="Copy install command"
    >
      {hasCopied ? <Check className="h-4 w-4 text-primary" /> : <Copy className="h-4 w-4" />}
    </Button>
  );
}

type TokenKind = "command" | "flag" | "url" | "pipe" | "text";

const KNOWN_COMMANDS = new Set(["irm", "iex", "curl", "bash", "sh", "wget", "powershell", "pwsh"]);

function classifyToken(token: string, index: number): TokenKind {
  if (token === "|" || token === "&&" || token === "||" || token === ";") return "pipe";
  if (/^https?:\/\//i.test(token)) return "url";
  if (/^-/.test(token)) return "flag";
  if (index === 0 || KNOWN_COMMANDS.has(token.toLowerCase())) return "command";
  return "text";
}

const TOKEN_CLASS: Record<TokenKind, string> = {
  command: "text-primary font-medium",
  flag: "text-accent-foreground/80",
  url: "text-muted-foreground/90 underline decoration-dotted decoration-muted-foreground/40 underline-offset-2",
  pipe: "text-destructive/80 font-semibold",
  text: "text-foreground/85",
};

function HighlightedCommand({ command }: { command: string }) {
  const tokens = command.split(/(\s+)/);
  let nonSpaceIndex = -1;
  return (
    <>
      {tokens.map((token, i) => {
        if (/^\s+$/.test(token)) return <span key={i}>{token}</span>;
        nonSpaceIndex += 1;
        const kind = classifyToken(token, nonSpaceIndex);
        return (
          <span key={i} className={TOKEN_CLASS[kind]}>
            {token}
          </span>
        );
      })}
    </>
  );
}

function InstallCard({ item }: { item: InstallCommand }) {
  return (
    <Card className="overflow-hidden border-border/60 bg-card/50 transition-colors hover:border-primary/40">
      <CardHeader className="pb-3">
        <CardTitle className="flex items-center gap-2 text-base font-semibold text-foreground">
          <Terminal className="h-4 w-4 text-primary" />
          {item.platform}
          <span className="ml-auto rounded-full border border-border bg-secondary px-2 py-0.5 text-xs font-medium text-muted-foreground">
            {item.shell}
          </span>
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="flex items-center gap-2 rounded-md border border-border bg-secondary/60 px-3 py-2.5 font-mono text-foreground/90">
          <span className="mr-1 select-none text-muted-foreground/60">$</span>
          <code className="flex-1 break-all text-[11px] leading-relaxed sm:text-xs md:text-sm md:break-normal md:whitespace-nowrap">
            <HighlightedCommand command={item.command} />
          </code>
          <CopyButton command={item.command} />
        </div>
      </CardContent>
    </Card>
  );
}

export function InstallSection() {
  return (
    <section className="border-y border-border bg-secondary/20 py-20">
      <div className="mx-auto max-w-6xl px-6">
        <div className="mb-10 text-center">
          <div className="flex items-center justify-center gap-3">
            <h2 className="text-3xl font-bold text-foreground">Install in One Line</h2>
            <Badge variant="secondary" className="text-xs">
              Latest: v{versionData.version}
            </Badge>
          </div>
          <p className="mt-3 text-muted-foreground">
            Version-pinned install scripts with SHA-256 verification
          </p>
        </div>
        <div className="flex flex-col gap-4">
          {installCommands.map((item) => (
            <InstallCard key={item.platform} item={item} />
          ))}
        </div>

        <div className="mt-16">
          <div className="mb-6 text-center">
            <h3 className="text-2xl font-bold text-foreground">Named Bundle Installers</h3>
            <p className="mt-2 text-sm text-muted-foreground">
              Install just the spec folders you need — each bundle wraps the main installer with a curated folder list.
            </p>
          </div>
          <div className="grid gap-4 md:grid-cols-2">
            {bundleCommands.map((bundle) => (
              <BundleCard key={bundle.bundle} bundle={bundle} />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

function BundleCard({ bundle }: { bundle: BundleCommand }) {
  const [tab, setTab] = useState<"install" | "download">("install");
  return (
    <Card className="overflow-hidden border-border/60 bg-card/50 transition-colors hover:border-primary/40">
      <CardHeader className="pb-3">
        <CardTitle className="flex items-center gap-2 text-base font-semibold text-foreground">
          <Package className="h-4 w-4 text-primary" />
          <span className="font-mono text-sm">{bundle.bundle}</span>
          <span className="ml-auto rounded-full border border-border bg-secondary px-2 py-0.5 text-xs font-medium text-muted-foreground">
            {bundle.folders.length} folder{bundle.folders.length === 1 ? "" : "s"}
          </span>
        </CardTitle>
        <p className="mt-1 text-xs text-muted-foreground">{bundle.description}</p>
      </CardHeader>
      <CardContent className="space-y-2">
        <div
          role="tablist"
          aria-label={`${bundle.bundle} command mode`}
          className="inline-flex rounded-md border border-border bg-secondary/40 p-0.5 text-[11px] font-medium"
        >
          <button
            role="tab"
            aria-selected={tab === "install"}
            onClick={() => setTab("install")}
            className={`rounded px-2.5 py-1 transition-colors ${
              tab === "install"
                ? "bg-primary text-primary-foreground"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            One-liner install
          </button>
          <button
            role="tab"
            aria-selected={tab === "download"}
            onClick={() => setTab("download")}
            className={`rounded px-2.5 py-1 transition-colors ${
              tab === "download"
                ? "bg-primary text-primary-foreground"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            Download archive
          </button>
        </div>
        {tab === "install" ? (
          <>
            <BundleCommandRow label="bash" command={bundle.bash} />
            <BundleCommandRow label="pwsh" command={bundle.ps} />
          </>
        ) : (
          <>
            <BundleCommandRow label="bash" command={bundle.downloadBash} />
            <BundleCommandRow label="pwsh" command={bundle.downloadPwsh} />
            <div className="flex flex-wrap gap-2 pt-1">
              <a
                href={bundle.archiveTar}
                className="rounded-md border border-border/60 bg-secondary/40 px-2 py-1 font-mono text-[10px] text-muted-foreground transition-colors hover:border-primary/50 hover:text-foreground"
              >
                .tar.gz
              </a>
              <a
                href={bundle.archiveZip}
                className="rounded-md border border-border/60 bg-secondary/40 px-2 py-1 font-mono text-[10px] text-muted-foreground transition-colors hover:border-primary/50 hover:text-foreground"
              >
                .zip
              </a>
            </div>
          </>
        )}
        <ul className="mt-2 flex flex-wrap gap-1.5">
          {bundle.folders.map((folder) => (
            <li
              key={folder}
              className="rounded-md border border-border/60 bg-secondary/40 px-2 py-0.5 font-mono text-[10px] text-muted-foreground"
            >
              {folder}
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}

function BundleCommandRow({ label, command }: { label: string; command: string }) {
  return (
    <div className="flex items-center gap-2 rounded-md border border-border bg-secondary/60 px-3 py-2 font-mono text-foreground/90">
      <span className="select-none text-[10px] font-semibold uppercase tracking-wide text-muted-foreground/80">
        {label}
      </span>
      <code className="flex-1 break-all text-[11px] leading-relaxed sm:text-xs">
        <HighlightedCommand command={command} />
      </code>
      <CopyButton command={command} />
    </div>
  );
}
