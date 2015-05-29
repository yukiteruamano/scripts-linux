__module_name__ = "Audacious2 MP3"
__module_version__ = "1.0"
__module_description__ = "Otorga informacion sobre la reproduccion de musica en Audacious"

from dbus import Bus, DBusException
import xchat
import commands
bus = Bus(Bus.TYPE_SESSION)

def check_audacious():
    try:
        return bus.get_object('org.mpris.audacious', '/Player')
    except DBusException:
        print "\x02Audacious no esta ejecutandose, o ha ocurrido un error en el subsistema DBUS"
        return None

def mp3_info(word, word_eol, userdata):

    check_audacious()
    artist = commands.getoutput("audtool --current-song-tuple-data artist")
    titulo = commands.getoutput("audtool --current-song-tuple-data title")
    album = commands.getoutput("audtool --current-song-tuple-data album")
    bitrate = commands.getoutput("audtool --current-song-tuple-data bitrate")
    genero = commands.getoutput("audtool --current-song-tuple-data genre")
    calidad = commands.getoutput("audtool --current-song-tuple-data quality")
    duracion = commands.getoutput("audtool --current-song-length")

    xchat.command("me || Audacious: (" + artist + " - " +  titulo + " - " + album + " - " + duracion +") - ("  + bitrate + " kbps - " + genero + " - " + calidad + ") ||"  )
    return xchat.EAT_ALL

xchat.hook_command("aump3", mp3_info, help="Despliega la informacion de la reproduccion en Audacious")

print "Audacious MP3 loaded for XChat IRC"
