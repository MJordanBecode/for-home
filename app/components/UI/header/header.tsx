import Image from "next/image";
import Link from "next/link";
export default function NavBarHeader() {
  return (
    <nav className="border inline-flex flex-col items-center justify-between w-1/5 h-screen bg-white border-gray-200 dark:bg-gray-800 dark:border-gray-700 ">
      <Link href="/">
        <div>
          <Image src="/logoSITE.png" alt="Logo" width={100} height={100} />
          <p>Espace Premium</p>
        </div>
      </Link>
      <div className="flex flex-col m-4">
        <div className="flex gap-1 items-center">
          <Image src="/dashboard/house.svg" alt="Logo" width={25} height={25} />
          <p>Accueil</p>
        </div>
        <div className="flex gap-1 items-center">
          <Image
            src="/dashboard/calendar-days.svg"
            alt="Logo"
            width={25}
            height={25}
          />
          <p>Agenda</p>
        </div>
        <div className="flex gap-1 items-center">
          <Image
            src="/dashboard/list-todo.svg"
            alt="Logo"
            width={25}
            height={25}
          />
          <p>Tâches</p>
        </div>
        <div className="flex gap-1 items-center">
          <Image
            src="/dashboard/file-text.svg"
            alt="Logo"
            width={25}
            height={25}
          />
          <p>Notes</p>
        </div>
        <div className="flex gap-1 items-center">
          <Image
            src="/dashboard/briefcase.svg"
            alt="Logo"
            width={25}
            height={25}
          />
          <p>Projets</p>
        </div>
      </div>
      <div>
        <div>
          <div>
            <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center text-primary">
              <Image
                src="/dashboard/user.svg"
                alt="Logo"
                width={20}
                height={20}
              />
            </div>
          </div>
        </div>
        <div className="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 bg-background hover:bg-accent hover:text-accent-foreground w-9 h-9 rounded-md border border-border luxury-border focus-ring">
          <Image
            src="/dashboard/moon.svg"
            alt="Logo"
            width={20}
            height={20}
            className="rotate-180 m-1"
          />
        </div>
      </div>
    </nav>
  );
}
