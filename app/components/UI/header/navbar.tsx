"use client"
import Image from "next/image"
import Link from "next/link";
export default function Navbar(){

    return(
        <nav className="border-r border-r-2">
            <div className="flex flex-col ">
                <div>
                    <Image
                    width={100}
                    height={100}
                    src={"/logoSITE.png"}
                    alt="Logo"
                    />
                </div>
                <p>
                    Espace Prenium
                </p>
            </div>
        </nav>
    )
}