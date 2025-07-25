"use client";

import type { VariantProps } from "class-variance-authority";

import { cva } from "class-variance-authority";
import { Clipboard, Copy } from "lucide-react";
import * as React from "react";
import { toast } from "sonner";
import Link from "next/link";

import { basePath } from "@/config/site-config";
import { cn } from "@/lib/utils";

import { Separator } from "./separator";
import { Button } from "./button";

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:border-primary hover:text-accent-foreground",
        secondary:
          "bg-secondary border-secondary text-secondary-foreground hover:bg-secondary/80 hover:border-primary",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
        null: "py-1 px-3 rouded-xs",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  },
);

function handleCopy(type: string, value: string) {
  navigator.clipboard.writeText(value);

  let amountOfScriptsCopied = localStorage.getItem("amountOfScriptsCopied");

  if (amountOfScriptsCopied === null) {
    localStorage.setItem("amountOfScriptsCopied", "1");
  }
  else {
    amountOfScriptsCopied = (Number.parseInt(amountOfScriptsCopied) + 1).toString();
    localStorage.setItem("amountOfScriptsCopied", amountOfScriptsCopied);

    if (
      Number.parseInt(amountOfScriptsCopied) === 3
      || Number.parseInt(amountOfScriptsCopied) === 10
      || Number.parseInt(amountOfScriptsCopied) === 25
      || Number.parseInt(amountOfScriptsCopied) === 50
      || Number.parseInt(amountOfScriptsCopied) === 100
    ) {
      setTimeout(() => {
        toast.info(
          <div className="flex flex-col gap-3">
            <p className="lg">
              If you find these scripts useful, please consider starring the
              repository on GitHub. It helps a lot!
            </p>
            <div>
              <Button className="text-white">
                <Link
                  href={`https://github.com/ogizhelev/${basePath}`}
                  data-umami-event="Star on Github"
                  target="_blank"
                >
                  Star on GitHub 💫
                </Link>
              </Button>
            </div>
          </div>,
          { duration: 8000 },
        );
      }, 500);
    }
  }

  toast.success(
    <div className="flex items-center gap-2">
      <Clipboard className="h-4 w-4" />
      <span>
        Copied
        {type}
        {" "}
        to clipboard
      </span>
    </div>,
  );
}

export type CodeBlockProps = {
  asChild?: boolean;
  code: string;
} & React.ButtonHTMLAttributes<HTMLButtonElement> & VariantProps<typeof buttonVariants>;

const CodeBlock = React.forwardRef<HTMLDivElement, CodeBlockProps>(
  ({ className, variant, size, asChild = false, code }, ref) => {
    const copyToClipboard = () => {
      navigator.clipboard.writeText(code);
    };

    return (
      <div
        style={{
          position: "relative",
          marginBottom: "1rem",
          display: "flex",
          gap: "8px",
        }}
        ref={ref}
      >
        <pre
          className={cn(
            buttonVariants({ variant, size, className }),
            " flex flex-row p-4",
          )}
        >
          <p className="flex items-center gap-2">
            {code}
            {" "}
            <Separator orientation="vertical" />
            {" "}
            <Copy
              className="cursor-pointer"
              size={16}
              onClick={() => handleCopy("install command", code)}
            />
          </p>
        </pre>
      </div>
    );
  },
);
CodeBlock.displayName = "CodeBlock";

export { buttonVariants, CodeBlock };
