"use client";
import { ArrowRightIcon, ExternalLink } from "lucide-react";
import { useEffect, useState } from "react";
import { FaGithub } from "react-icons/fa";
import { useTheme } from "next-themes";
import Link from "next/link";

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import AnimatedGradientText from "@/components/ui/animated-gradient-text";
import { Separator } from "@/components/ui/separator";
import { CardFooter } from "@/components/ui/card";
import Particles from "@/components/ui/particles";
import { Button } from "@/components/ui/button";
import { basePath } from "@/config/site-config";
import FAQ from "@/components/faq";
import { cn } from "@/lib/utils";

function CustomArrowRightIcon() {
  return <ArrowRightIcon className="h-4 w-4" width={1} />;
}

export default function Page() {
  const { theme } = useTheme();

  const [color, setColor] = useState("#000000");

  useEffect(() => {
    setColor(theme === "dark" ? "#ffffff" : "#000000");
  }, [theme]);

  return (
    <>
      <div className="w-full mt-16">
        <Particles className="absolute inset-0 -z-40" quantity={100} ease={80} color={color} refresh />
        <div className="container mx-auto">
          <div className="flex h-[80vh] flex-col items-center justify-center gap-4 py-20 lg:py-40">
            <Dialog>
              <DialogTrigger>
                <div>
                  <AnimatedGradientText>
                    <div
                      className={cn(
                        `absolute inset-0 block size-full animate-gradient bg-gradient-to-r from-[#ffaa40]/50 via-[#9c40ff]/50 to-[#ffaa40]/50 bg-[length:var(--bg-size)_100%] [border-radius:inherit] [mask:linear-gradient(#fff_0_0)_content-box,linear-gradient(#fff_0_0)]`,
                        `p-px ![mask-composite:subtract]`,
                      )}
                    />
                    ❤️
                    {" "}
                    <Separator className="mx-2 h-4" orientation="vertical" />
                    <span
                      className={cn(
                        `animate-gradient bg-gradient-to-r from-[#ffaa40] via-[#9c40ff] to-[#ffaa40] bg-[length:var(--bg-size)_100%] bg-clip-text text-transparent`,
                        `inline`,
                      )}
                    >
                      Scripts by tteck
                    </span>
                  </AnimatedGradientText>
                </div>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Thank You!</DialogTitle>
                  <DialogDescription>
                    A big thank you to tteck and the many contributors who have made this project possible. Your hard
                    work is truly appreciated by the entire Proxmox community!
                  </DialogDescription>
                </DialogHeader>
                <CardFooter className="flex flex-col gap-2">
                  <Button className="w-full" variant="outline" asChild>
                    <a
                      href="https://github.com/tteck"
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-center"
                    >
                      <FaGithub className="mr-2 h-4 w-4" />
                      {" "}
                      Tteck&apos;s GitHub
                    </a>
                  </Button>
                  <Button className="w-full" asChild>
                    <a
                      href={`https://github.com/ogizhelev/${basePath}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-center"
                    >
                      <ExternalLink className="mr-2 h-4 w-4" />
                      {" "}
                      Proxmox Helper Scripts
                    </a>
                  </Button>
                </CardFooter>
              </DialogContent>
            </Dialog>

            <div className="flex flex-col gap-4">
              <h1 className="max-w-2xl text-center text-3xl font-semibold tracking-tighter md:text-7xl">
                Make managing your Homelab a breeze
              </h1>
              <div className="max-w-2xl gap-2 flex flex-col text-center sm:text-lg text-sm leading-relaxed tracking-tight text-muted-foreground md:text-xl">
                <p>
                  We are a community-driven initiative that simplifies the setup of Proxmox Virtual Environment (VE).
                </p>
                <p>
                  With 300+ scripts to help you manage your
                  {" "}
                  <b>Proxmox VE environment</b>
                  . Whether you&#39;re a seasoned
                  user or a newcomer, we&#39;ve got you covered.
                </p>
              </div>
            </div>
            <div className="flex flex-row gap-3">
              <Link href="/scripts">
                <Button
                  size="lg"
                  variant="expandIcon"
                  Icon={CustomArrowRightIcon}
                  iconPlacement="right"
                  className="hover:"
                >
                  View Scripts
                </Button>
              </Link>
            </div>
          </div>

          {/* FAQ Section */}
          <div className="py-20" id="faq">
            <div className="max-w-4xl mx-auto px-4">
              <div className="text-center mb-12">
                <h2 className="text-3xl font-bold tracking-tighter md:text-5xl mb-4">Frequently Asked Questions</h2>
                <p className="text-muted-foreground text-lg">
                  Find answers to common questions about our Proxmox VE scripts
                </p>
              </div>
              <FAQ />
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
